#!/usr/bin/env bash

set -e

if command -v aws >/dev/null 2>&1; then
  echo "AWS CLI já está instalado."
  aws --version
  exit 0
fi

echo "AWS CLI não encontrado. Instalando..."

TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}

trap cleanup EXIT

cd "$TMP_DIR"

echo "Baixando AWS CLI v2..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

echo "Extraindo arquivos..."
unzip -q awscliv2.zip

echo "Instalando AWS CLI..."
sudo ./aws/install

echo "AWS CLI instalado com sucesso:"
aws --version