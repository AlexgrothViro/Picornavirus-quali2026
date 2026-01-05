#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f config.env ]]; then
  echo "[ERRO] config.env não existe. Crie com: cp config.env.example config.env"
  exit 1
fi
source config.env

command -v blastn >/dev/null 2>&1 || { echo "[ERRO] blastn não encontrado"; exit 1; }

CONTIGS="data/assemblies/${SAMPLE_NAME}_assembly/contigs.fa"
DB="${DB_ROOT:-data/db}/${DB_NAME}/${DB_NAME}"
OUT="results/blast/${SAMPLE_NAME}_vs_${DB_NAME}.tsv"

mkdir -p results/blast

[[ -s "$CONTIGS" ]] || { echo "[ERRO] contigs não encontrados e/ou vazios: $CONTIGS"; exit 1; }

echo "[BLAST] contigs=$CONTIGS"
echo "[BLAST] db=$DB"
echo "[BLAST] evalue=$BLAST_EVALUE threads=$THREADS"

blastn \
  -query "$CONTIGS" \
  -db "$DB" \
  -evalue "${BLAST_EVALUE:-1e-5}" \
  -max_target_seqs "${BLAST_MAX_TARGET_SEQS:-20}" \
  -num_threads "${THREADS:-4}" \
  -outfmt 6 \
  > "$OUT"

echo "[BLAST] OK: $OUT"
