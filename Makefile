# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Source: https://stackoverflow.com/a/10858332
# Params:
#   1. Variable name(s) to test.
#   2. (optional) Error message to print.
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined '$1'$(if $2, ($2))))

ifndef inventory
override inventory = staging
endif
ifndef playbook
override playbook = media
endif

prepare:
	./prepare.sh

installer:
	sudo ./installer/make-iso.sh

ansible:
	ansible-playbook \
		--vault-id default@./secrets/.ansible-vault-password \
		-i ./ansible/inventories/$(inventory).yml \
		ansible/$(playbook).yml

ansible-check:
	ansible-playbook \
		--vault-id default@./secrets/.ansible-vault-password \
		-i ./ansible/inventories/$(inventory).yml \
		--check
		ansible/$(playbook).yml

ansible-encrypt:|check-defined-file
	ansible-vault encrypt \
		--vault-id default@./secrets/.ansible-vault-password \
		$(file)

ansible-decrypt:|check-defined-file
	ansible-vault decrypt \
		--vault-id default@./secrets/.ansible-vault-password \
		$(file)

check-defined-% : __check_defined_FORCE
	@:$(call check_defined, $*)

.PHONY: __check_defined_FORCE installer ansible
__check_defined_FORCE:
