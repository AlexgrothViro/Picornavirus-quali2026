#!/usr/bin/env bash
set -euo pipefail

SAMPLE="${1:?SAMPLE obrigatório}"
KMER="${2:?KMER obrigatório}"

DB="${BLAST_DB:-blastdb/ptv}"
THREADS="${BLAST_THREADS:-4}"

CONTIGS="data/assemblies/${SAMPLE}_velvet_k${KMER}/contigs.fa"
OUTDIR="results/blast"
OUT="${OUTDIR}/${SAMPLE}_k${KMER}_vs_db.tsv"

mkdir -p "$OUTDIR"

if [[ ! -s "$CONTIGS" ]]; then
  echo "[ERRO] contigs.fa não encontrado: $CONTIGS" >&2
  exit 1
fi

echo "[$(date)] Rodando blastn contra $DB..."
blastn -query "$CONTIGS" -db "$DB" \
  -outfmt '6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore' \
  -max_target_seqs 5 -evalue 1e-5 -num_threads "$THREADS" > "$OUT"

# compat legado (alguns scripts antigos podem ler o nome sem kmer)
ln -sf "$(basename "$OUT")" "${OUTDIR}/${SAMPLE}_vs_db.tsv"

echo "[$(date)] Resultado salvo em: $OUT"
