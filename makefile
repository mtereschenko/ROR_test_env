# Make stuff
include .env
.DEFAULT_GOAL := help
.PHONY: help

DEVELOPMENT_DOMAIN := "${PROJECT_NAME}.localhost"

SSL_CERTS_DIRECTORY := "./environment/ssl"
ARTIFACTS_DIRECTORY := "./environment/artifacts"

SHELL_CONTAINER_NAME := $(if $(c),$(c),"ruby")
BUILD_TARGET := $(if $(t),$(t),"development")

help: ## help
	@grep -E '^[a-zA-Z-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "[32m%-27s[0m %s\n", $$1, $$2}'

build: ## Building application images.
	@docker-compose -f docker-compose.$(BUILD_TARGET).yml build

start: ## Start previously builded application images.
	@mkdir -p $(ARTIFACTS_DIRECTORY)
	@make generate-ssl
	@PROJECT_NAME=$(PROJECT_NAME) docker-compose -f docker-compose.$(BUILD_TARGET).yml up

drop: ## Stop and remove application images.
	@make stop
	@docker-compose -f docker-compose.$(BUILD_TARGET).yml rm -v

stop: ## Stop and remove containers and resources.
	@HOST_GID=$(HOST_GID) HOST_UID=$(HOST_UID) docker-compose -f docker-compose.$(BUILD_TARGET).yml down
	@rm -rf $(ARTIFACTS_DIRECTORY)
	@make clean-ssl

shell: ## Internal image bash comand line.
	@HOST_GID=$(HOST_GID) HOST_UID=$(HOST_UID) docker-compose -f docker-compose.$(BUILD_TARGET).yml exec $(SHELL_CONTAINER_NAME) /bin/ash

# Internal commands (not for public usage)
generate-ssl:
	@mkcert -install
	@mkdir -p $(SSL_CERTS_DIRECTORY)
	@mkcert -cert-file $(SSL_CERTS_DIRECTORY)/dev-cert.pem \
            -key-file $(SSL_CERTS_DIRECTORY)/dev-key.pem \
            $(DEVELOPMENT_DOMAIN)

clean-ssl:
	@rm -rf $(SSL_CERTS_DIRECTORY)
