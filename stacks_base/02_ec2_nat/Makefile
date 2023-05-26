#
# Makefile
#

ENV           := dev
TFLOCALS_G    := ../../global/locals.tf
TFLOCALS_A    := ../locals_all.tf
TFLOCALS_E    := ../locals_$(ENV).tf
TFLOCALS_S    := ./locals.tf.$(ENV)
TFVERSION_G   := ../../global/versions.tf
TFVERSION_S   := ./versions.tf
TFSTATE_DIR   := ./_tfstate.d/${ENV}
TFSTATE_FILE  := $(TFSTATE_DIR)/terraform.tfstate
TFBACKEND_G   := ../../global/backend.tf
TFCACHE_DIR   := ~/.terraform.d/plugin-cache

ifeq ("$(ENV)","prd")
  TFPROVIDER_G := ../../global/providers_aws.tf
else ifeq ("$(ENV)","stg")
  TFPROVIDER_G := ../../global/providers_aws.tf
else
  TFPROVIDER_G := ../../global/providers_localstack.tf
endif

init:
	-@rm -rf ./.terraform > /dev/null 2>&1
	-@rm -f ./_backend.tf > /dev/null 2>&1
	-@rm -f ./_providers.tf > /dev/null 2>&1
	-@rm -f ./_versions.tf > /dev/null 2>&1
	-@rm -f ./_locals*.tf > /dev/null 2>&1
	@ln -s $(TFBACKEND_G) ./_backend.tf
	@ln -s $(TFPROVIDER_G) ./_providers.tf
	@ln -s $(TFLOCALS_G) ./_locals_global.tf
	@ln -s $(TFLOCALS_A) ./_locals_all.tf
	@ln -s $(TFLOCALS_E) ./_locals_env.tf
	@if [ -f "$(TFLOCALS_S)" ]; then ln -s $(TFLOCALS_S) ./_locals.tf; fi
	@if [ ! -f "$(TFVERSION_S)" ]; then ln -s $(TFVERSION_G) ./_versions.tf; fi
	@mkdir -p $(TFSTATE_DIR)
	@mkdir -p $(TFCACHE_DIR)
	TF_PLUGIN_CACHE_DIR=$(TFCACHE_DIR) terraform init
	@echo "-----------------------------------------------------"

# tflint
# - 未使用のvariable,datasourceはOKにします
lint:
	make --no-print-directory init
	tflint --disable-rule=terraform_unused_declarations

plan:
	make --no-print-directory lint
	@echo "-----------------------------------------------------"
	terraform plan \
	-state=$(TFSTATE_FILE) $(OPT)

apply:
	make --no-print-directory lint
	@echo "-----------------------------------------------------"
	terraform apply \
	-state=$(TFSTATE_FILE) $(OPT)

destroy:
	make --no-print-directory lint
	@echo "-----------------------------------------------------"
	terraform destroy \
	-state=$(TFSTATE_FILE) $(OPT)

import:
	make --no-print-directory init > /dev/null 2>&1
	terraform import \
	-state=$(TFSTATE_FILE) $(OPT)

output:
	make --no-print-directory init > /dev/null 2>&1
	terraform output \
	-state=$(TFSTATE_FILE) $(OPT)

list:
	make --no-print-directory init > /dev/null 2>&1
	terraform state list \
	-state=$(TFSTATE_FILE) $(OPT)

rm:
	make --no-print-directory init > /dev/null 2>&1
	terraform state rm \
	-state=$(TFSTATE_FILE) $(OPT)

mv:
	make --no-print-directory init > /dev/null 2>&1
	terraform state mv \
	-state=$(TFSTATE_FILE) $(OPT)

clean:
	rm -fr .terraform .terraform.lock.hcl _*
