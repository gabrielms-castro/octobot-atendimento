#!/bin/bash
set -e

BACKUP_DIR="./n8n_volume_backup_$(date +%Y%m%d_%H%M%S)"

docker cp octobot-n8n:/home/node/.n8n "$BACKUP_DIR"

echo "Backup salvo em: $BACKUP_DIR"