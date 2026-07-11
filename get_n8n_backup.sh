#!/bin/bash
docker exec octobot-n8n sh -lc '
  cd /home/node &&
  wget -O backup.tar "https://octo-backups-asdf98.s3.us-east-1.amazonaws.com/n8n_volume_backup.tar" &&
  tar -xf backup.tar &&
  rm backup.tar
'