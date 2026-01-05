include config.env

.PHONY: all db assembly blast

# No Makefile:

# Ordem correta: Banco -> Filtro -> Montagem -> BLAST
all: db filter-host assembly blast

filter-host:
	bash scripts/03_filter_host.sh

# 1. Baixar banco (do vírus escolhido no config)
db:
	bash scripts/10_build_custom_db.sh

# 2. Rodar Montagem (escolhida no config)
assembly:
	bash scripts/run_assembly_router.sh

# 3. Rodar BLAST (com parametros do config)
blast:
	bash scripts/02_run_blast_generic.sh
