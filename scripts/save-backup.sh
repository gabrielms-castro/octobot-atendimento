#!/bin/bash
set -euo pipefail

# Carrega variáveis do .env
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "Arquivo .env não encontrado."
  exit 1
fi

# Configurações
CONTAINER="${CONTAINER:-octobot-n8n}"
BACKUP_DIR_CONTAINER="/tmp/workflows_backup"
BACKUP_NAME="workflows_backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"
BACKUP_FILE_HOST="./$BACKUP_NAME"
BACKUP_FILE_CONTAINER="/tmp/$BACKUP_NAME"

# Valida variáveis obrigatórias
: "${AWS_ACCESS_KEY_ID:?AWS_ACCESS_KEY_ID não definida no .env}"
: "${AWS_SECRET_ACCESS_KEY:?AWS_SECRET_ACCESS_KEY não definida no .env}"
: "${AWS_DEFAULT_REGION:?AWS_DEFAULT_REGION não definida no .env}"
: "${S3_BUCKET:?S3_BUCKET não definida no .env}"

echo "Iniciando backup do n8n..."
echo "Container: $CONTAINER"

# Remove backup antigo dentro do container, se existir
docker exec "$CONTAINER" rm -rf "$BACKUP_DIR_CONTAINER" "$BACKUP_FILE_CONTAINER"

# Exporta workflows do n8n dentro do container
docker exec "$CONTAINER" n8n export:workflow --backup --output="$BACKUP_DIR_CONTAINER"

# Compacta o diretório exportado dentro do container
docker exec "$CONTAINER" tar -czf "$BACKUP_FILE_CONTAINER" -C /tmp workflows_backup

# Copia o arquivo compactado para o host
docker cp "$CONTAINER:$BACKUP_FILE_CONTAINER" "$BACKUP_FILE_HOST"

echo "Backup salvo no host em: $BACKUP_FILE_HOST"

# Envia para o S3
echo "Enviando backup para S3..."

aws s3 cp "$BACKUP_FILE_HOST" "s3://$S3_BUCKET/${S3_PREFIX:-n8n}/$BACKUP_NAME"

echo "Upload concluído:"
echo "s3://$S3_BUCKET/${S3_PREFIX:-n8n}/$BACKUP_NAME"

# Limpeza opcional dentro do container
docker exec "$CONTAINER" rm -rf "$BACKUP_DIR_CONTAINER" "$BACKUP_FILE_CONTAINER"

# Limpa arquivo temporário no host
echo "Limpando arquivo temporário no host..."
rm -f "$BACKUP_FILE_HOST"

echo "Backup finalizado com sucesso."