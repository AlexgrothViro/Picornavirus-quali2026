#!/usr/bin/env bash
set -euo pipefail

# Recebe argumentos vindos do router
SAMPLE="$1"
THREADS="$2"
# O terceiro argumento pega todo o resto da string de parametros (ex: "--rnaviral -k ...")
PARAMS="${@:3}" 

# Definição de caminhos
# IMPORTANTE: SPAdes espera ler arquivos LIMPOS (sem hospedeiro)
IN_DIR="data/host_removed"
OUT_DIR="data/assemblies/${SAMPLE}_spades"
R1="${IN_DIR}/${SAMPLE}_R1.host_removed.fastq.gz"
R2="${IN_DIR}/${SAMPLE}_R2.host_removed.fastq.gz"

echo "[SPAdes] Iniciando montagem para $SAMPLE..."
echo "[SPAdes] Params: $PARAMS"

if [[ ! -f "$R1" ]]; then
    echo "ERRO: Input $R1 não encontrado. Rode o filtro de host antes!"
    exit 1
fi

# Comando do SPAdes
# Nota: Usamos 'eval' ou passamos direto dependendo de como o bash interpreta as aspas,
# mas aqui vamos passar direto assumindo que o spades.py aceita a string.
spades.py $PARAMS \
    -1 "$R1" \
    -2 "$R2" \
    -o "$OUT_DIR" \
    -t "$THREADS"

# Padroniza a saída para o BLAST (copia contigs.fasta para onde o BLAST espera)
# O BLAST espera em data/assemblies/NOME_contigs.fa (baseado no script 02)
cp "${OUT_DIR}/contigs.fasta" "data/assemblies/${SAMPLE}_contigs.fa"

echo "[SPAdes] Sucesso. Contigs salvos em data/assemblies/${SAMPLE}_contigs.fa"
