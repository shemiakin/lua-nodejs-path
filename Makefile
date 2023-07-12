#!/usr/bin/make
# Makefile Readme: https://www.gnu.org/software/make/manual/html_node/index.html#SEC_Contents

PACKAGE = nodejs-path
ROCKSPEC_FILE := $(shell ls | grep *.rockspec)

#.PHONY : help install shell root-shell init test test-cover up down restart logs clean
.PHONY : print test push rock
.DEFAULT_GOAL : help

# See https://stackoverflow.com/questions/1789594/how-do-i-write-the-cd-command-in-a-makefile
.SHELLFLAGS += -e -c
.ONESHELL :

# This will output the help for each task. Thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Show this help
	@printf "\033[33m%s:\033[0m\n" 'Available commands'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "  \033[32m%-18s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

test: ## Execute tests
	busted ./

push: ## Push to the Github
	git push -u origin main --tags

rock: ## Сreate .rock file
	luarocks pack $(ROCKSPEC_FILE)
