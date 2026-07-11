#!/bin/bash
docker exec octobot-n8n sh -lc '
  cd /home/node/.n8n &&
  wget -O backup.tar.gz "s3://octo-backups-asdf98/n8n_volume_backup_20260710_214421.tar" &&
  tar -xzf backup.tar.gz &&
  rm backup.tar.gz
'