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
S3_PREFIX="${S3_PREFIX:-n8n}"

RESTORE_FILE_HOST="./latest_workflows_backup.tar.gz"
RESTORE_FILE_CONTAINER="/tmp/latest_workflows_backup.tar.gz"
RESTORE_DIR_CONTAINER="/tmp/restored_workflows_backup"

# Valida variáveis obrigatórias
: "${AWS_ACCESS_KEY_ID:?AWS_ACCESS_KEY_ID não definida no .env}"
: "${AWS_SECRET_ACCESS_KEY:?AWS_SECRET_ACCESS_KEY não definida no .env}"
: "${AWS_DEFAULT_REGION:?AWS_DEFAULT_REGION não definida no .env}"
: "${S3_BUCKET:?S3_BUCKET não definida no .env}"

echo "Buscando último backup no S3..."
echo "Bucket: $S3_BUCKET"
echo "Prefix: $S3_PREFIX"

LATEST_KEY=$(aws s3api list-objects-v2 \
  --bucket "$S3_BUCKET" \
  --prefix "$S3_PREFIX/" \
  --query 'sort_by(Contents[?ends_with(Key, `.tar.gz`)], &LastModified)[-1].Key' \
  --output text)

if [ "$LATEST_KEY" = "None" ] || [ -z "$LATEST_KEY" ]; then
  echo "Nenhum backup .tar.gz encontrado em s3://$S3_BUCKET/$S3_PREFIX/"
  exit 1
fi

echo "Último backup encontrado:"
echo "s3://$S3_BUCKET/$LATEST_KEY"

echo "Baixando backup para o host..."

aws s3 cp "s3://$S3_BUCKET/$LATEST_KEY" "$RESTORE_FILE_HOST"

echo "Backup baixado em: $RESTORE_FILE_HOST"

echo "Limpando arquivos antigos dentro do container..."

docker exec "$CONTAINER" rm -rf "$RESTORE_FILE_CONTAINER" "$RESTORE_DIR_CONTAINER"

echo "Copiando backup para dentro do container..."

docker cp "$RESTORE_FILE_HOST" "$CONTAINER:$RESTORE_FILE_CONTAINER"

echo "Extraindo backup dentro do container..."

docker exec "$CONTAINER" mkdir -p "$RESTORE_DIR_CONTAINER"

docker exec "$CONTAINER" tar -xzf "$RESTORE_FILE_CONTAINER" -C "$RESTORE_DIR_CONTAINER"

echo "Backup extraído dentro do container em:"
echo "$RESTORE_DIR_CONTAINER"

echo "Conteúdo extraído:"
docker exec "$CONTAINER" find "$RESTORE_DIR_CONTAINER" -maxdepth 3 -type f

echo "Importando workflows no n8n..."
docker exec "$CONTAINER" n8n import:workflow \
  --separate \
  --input="$RESTORE_DIR_CONTAINER"
echo "Workflows importados com sucesso."

echo "Limpando arquivos temporários do /tmp dentro do container..."
docker exec "$CONTAINER" rm -f "$RESTORE_FILE_CONTAINER"
docker exec "$CONTAINER" rm -rf "$RESTORE_DIR_CONTAINER"

echo "Restore preparado com sucesso."