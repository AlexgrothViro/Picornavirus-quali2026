#!/usr/bin/env bash
set -euo pipefail

# Carrega config
source config.env

DB_DIR="data/db/${DB_NAME}"
mkdir -p "$DB_DIR"

echo "[DB] Baixando sequências para TaxID: $TARGET_TAXID ..."

# Usa o esearch (EDirect) com o ID vindo do config
esearch -db nucleotide -query "txid${TARGET_TAXID}[Organism] AND refseq[filter]" | \
efetch -format fasta > "${DB_DIR}/${DB_NAME}.fasta"

echo "[DB] Construindo índice BLAST..."
makeblastdb -in "${DB_DIR}/${DB_NAME}.fasta" -dbtype nucl -out "${DB_DIR}/${DB_NAME}"

echo "[DB] Banco criado com sucesso para o TaxID $TARGET_TAXID"
