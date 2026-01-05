include config.env

.PHONY: all db assembly blast

all: db assembly blast

# 1. Baixar banco (do vírus escolhido no config)
db:
	bash scripts/10_build_custom_db.sh

# 2. Rodar Montagem (escolhida no config)
assembly:
	bash scripts/run_assembly_router.sh

# 3. Rodar BLAST (com parametros do config)
blast:
	bash scripts/02_run_blast_generic.sh
