#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f config.env ]]; then
  echo "[ERRO] config.env não existe. Crie com: cp config.env.example config.env"
  exit 1
fi
source config.env

command -v esearch >/dev/null 2>&1 || { echo "[ERRO] EDirect não encontrado (esearch). Instale EDirect."; exit 1; }
command -v efetch  >/dev/null 2>&1 || { echo "[ERRO] EDirect não encontrado (efetch). Instale EDirect."; exit 1; }
command -v makeblastdb >/dev/null 2>&1 || { echo "[ERRO] makeblastdb não encontrado (blast+)."; exit 1; }

DB_DIR="${DB_ROOT:-data/db}/${DB_NAME}"
FASTA="${DB_DIR}/${DB_NAME}.fasta"
BLASTDB="${DB_DIR}/${DB_NAME}"

mkdir -p "$DB_DIR"

QUERY="${NCBI_QUERY:-txid${TARGET_TAXID}[Organism:exp] AND refseq[filter]}"
RETMAX="${EDIRECT_RETMAX:-500}"

echo "[DB] Query: $QUERY"
echo "[DB] retmax: $RETMAX"
echo "[DB] Baixando FASTA..."

esearch -db nucleotide -query "$QUERY" -retmax "$RETMAX" | \
  efetch -format fasta > "$FASTA"

echo "[DB] Sequências baixadas: $(grep -c '^>' "$FASTA" || true)"
echo "[DB] Construindo BLAST DB..."
makeblastdb -in "$FASTA" -dbtype nucl -out "$BLASTDB" -parse_seqids

echo "[DB] OK: $BLASTDB"
