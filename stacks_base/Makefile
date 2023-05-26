#
# Makefile
#

#OPT           := -auto-approve
ENV           := dev
ALL_TARGETS   := $(shell find . -maxdepth 1 -type d | tr -d './' | sort)
ALL_TARGETS_R := $(shell find . -maxdepth 1 -type d | tr -d './' | sort -r)

list:
	@for target in $(ALL_TARGETS); do \
		echo ; \
		echo "*****************************************************"; \
		echo " $$target"; \
		echo "*****************************************************"; \
		make --no-print-directory -C $$target list; \
	done

lint:
	@for target in $(ALL_TARGETS); do \
		echo ; \
		echo "*****************************************************"; \
		echo " $$target"; \
		echo "*****************************************************"; \
		make --no-print-directory -C $$target lint; \
	done

plan:
	@for target in $(ALL_TARGETS); do \
		echo ; \
		echo "*****************************************************"; \
		echo " $$target"; \
		echo "*****************************************************"; \
		make --no-print-directory -C $$target plan; \
	done

apply:
	@for target in $(ALL_TARGETS); do \
		echo ; \
		echo "*****************************************************"; \
		echo " $$target"; \
		echo "*****************************************************"; \
		make --no-print-directory -C $$target apply; \
	done

destroy:
	@for target in $(ALL_TARGETS_R); do \
		echo ; \
		echo "*****************************************************"; \
		echo " $$target"; \
		echo "*****************************************************"; \
		make --no-print-directory -C $$target destroy; \
	done

clean:
	@for target in $(ALL_TARGETS); do \
		echo ; \
		echo "*****************************************************"; \
		echo " $$target"; \
		echo "*****************************************************"; \
		make --no-print-directory -C $$target clean; \
	done

fmt:
	terraform fmt --recursive

sync:
	@for target in $(ALL_TARGETS); do \
		cp ../stacks_template/00_check/.terraform-version $$target/; \
		cp ../stacks_template/00_check/Makefile $$target/; \
	done
