#!/bin/bash
set -e

CONTAINER="octobot-n8n"
BACKUP_FILE="n8n_volume_backup.tar"

docker exec "$CONTAINER" tar -cf - -C /home/node .n8n > "$BACKUP_FILE"

echo "Backup salvo em: $BACKUP_FILE"
