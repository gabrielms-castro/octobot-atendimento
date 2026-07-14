compose-restart:
	docker compose down && docker compose up -d

n8n-restore-backup:
	./scripts/restore-backup.sh

n8n-save-backup:
	./scripts/save-backup.sh