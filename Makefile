SCRIPTS ?= ./scripts/ ##				path to script files
PHP-TERM ?= ./scripts/term.sh ##			path to PHP-TERM script file
DOCKER-CLEAN ?= ./scripts/docker-clean.sh ##	path to DOCKER-CLEAN script file

## ┌───────────────────────────────────────────────────────────────────┐
## │                            Makefile                               │
## │ ───────────────────────────────────────────────────────────────── │
## │ I like to use the makefile to launch utility commands, it's lovely│
## │ for some productivity boosts, production maintenance, deploys,    │
## │ etc.                                                              │
## └───────────────────────────────────────────────────────────────────┘

.PHONY: help
help: ##		show this help
# regex for general help
	@sed -ne "s/^##\(.*\)/\1/p" $(MAKEFILE_LIST)
# regex for makefile commands (targets)
	@printf "────────────────────────`tput bold``tput setaf 2` Make Commands `tput sgr0`────────────────────────────────\n"
	@sed -ne "/@sed/!s/\(^[^#?=]*:\).*##\(.*\)/`tput setaf 2``tput bold`\1`tput sgr0`\2/p" $(MAKEFILE_LIST)
# regex for makefile variables
	@printf "────────────────────────`tput bold``tput setaf 4` Make Variables `tput sgr0`───────────────────────────────\n"
	@sed -ne "/@sed/!s/\(.*\)?=\(.*\)##\(.*\)/`tput setaf 4``tput bold`\1:`tput setaf 5`\2`tput sgr0`\3/p" $(MAKEFILE_LIST)

# make help the default
.DEFAULT_GOAL := help

.PHONY: php-comm
php-comm: ##	make php-comm COMMAND=php -v	execute a command in the php container
	@$(SCRIPTS)execute-command.sh mytheresa-php root "/bin/sh -c" "$(COMMAND)"

.PHONY: php-term
php-term: ##	make php-term			enter in the php shell container
	@$(PHP-TERM) mytheresa-php /bin/sh ||:

.PHONY: docker-clean
docker-clean: ##	docker-clean			remove unused stuff in docker (nice to make space)
	@$(DOCKER-CLEAN)

.PHONY: ps
ps: ##		ps				same as docker ps	 ¯\_(ツ)_/¯
	@docker ps

.PHONY: clear-ports
check-ports: ##	check-ports			check if the ports needed for the containers are available
	@printf "────────────────────────`tput bold``tput setaf 2` Checking port 80: `tput sgr0`──────────────────────────────────\n"
	@sudo lsof -i :80 ||:
	@printf "────────────────────────`tput bold``tput setaf 2` Checking port 443: `tput sgr0`─────────────────────────────────\n"
	@sudo lsof -i :443 ||:
	@printf "────────────────────────`tput bold``tput setaf 2` Checking port 5432: `tput sgr0`────────────────────────────────\n"
	@sudo lsof -i :5432 ||: