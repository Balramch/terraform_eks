.PHONY: help fmt validate lint init plan apply destroy bootstrap-backend

ENV ?= dev
ENV_DIR := environments/$(ENV)
BACKEND_CONFIG := $(ENV_DIR)/backend.hcl

help:
	@echo "Targets:"
	@echo "  make bootstrap-backend     Create S3 + DynamoDB for remote state"
	@echo "  make init ENV=dev          terraform init with backend.hcl"
	@echo "  make plan ENV=dev          terraform plan"
	@echo "  make apply ENV=dev         terraform apply"
	@echo "  make destroy ENV=dev       terraform destroy"
	@echo "  make fmt                   Format all Terraform"
	@echo "  make validate ENV=dev      terraform validate"
	@echo "  make lint                  Run tflint (if installed)"

bootstrap-backend:
	cd bootstrap/backend && terraform init && terraform apply

init:
	@test -f $(BACKEND_CONFIG) || (echo "Copy $(ENV_DIR)/backend.hcl.example to backend.hcl"; exit 1)
	cd $(ENV_DIR) && terraform init -backend-config=backend.hcl

plan: init
	cd $(ENV_DIR) && terraform plan -var-file=terraform.tfvars

apply: init
	cd $(ENV_DIR) && terraform apply -var-file=terraform.tfvars

destroy: init
	cd $(ENV_DIR) && terraform destroy -var-file=terraform.tfvars

fmt:
	terraform fmt -recursive .

validate: init
	cd $(ENV_DIR) && terraform validate

lint:
	tflint --chdir=$(ENV_DIR) --config=$(CURDIR)/.tflint.hcl
