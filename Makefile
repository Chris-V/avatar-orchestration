ifneq (,)
.error This Makefile requires GNU Make.
endif

ifndef inventory
override inventory = staging
endif

ifndef playbook
override playbook = all
endif

CURRENT_DIR       = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

FILE_LINT_VERSION = 0.4
YAML_LINT_VERSION = 1.25
LINT_IGNORE_PATHS = .git/,.idea/,.github/,.vscode/,*.md

.PHONY: lint
lint: _lint-files _lint-yaml

.PHONY: _pull-file-lint
_pull-file-lint:
	docker pull cytopia/file-lint:$(FILE_LINT_VERSION)

.PHONY: _pull-yaml-lint
_pull-yaml-lint:
	docker pull cytopia/yamllint:$(YAML_LINT_VERSION)

.PHONY: _lint-files
_lint-files: _pull-file-lint
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint:$(FILE_LINT_VERSION) file-cr --text --ignore '$(LINT_IGNORE_PATHS)' --path .
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint:$(FILE_LINT_VERSION) file-crlf --text --ignore '$(LINT_IGNORE_PATHS)' --path .
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint:$(FILE_LINT_VERSION) file-trailing-single-newline --text --ignore '$(LINT_IGNORE_PATHS)' --path .
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint:$(FILE_LINT_VERSION) file-trailing-space --text --ignore '$(LINT_IGNORE_PATHS)' --path .
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint:$(FILE_LINT_VERSION) file-utf8 --text --ignore '$(LINT_IGNORE_PATHS)' --path .
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint:$(FILE_LINT_VERSION) file-utf8-bom --text --ignore '$(LINT_IGNORE_PATHS)' --path .

.PHONY: _lint-yaml
_lint-yaml: _pull-yaml-lint
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(CURRENT_DIR):/data cytopia/yamllint:$(YAML_LINT_VERSION) . --strict

.PHONY: prepare
prepare:
	./prepare.sh

.PHONY: installer
installer:
	sudo ./installer/make-iso.sh

.PHONY: ansible
ansible:
	ansible-playbook \
		-i ./ansible/inventories/$(inventory)/inventory.yml \
		$(args) \
		ansible/$(playbook).yml

.PHONY: check
ansible-check:
	ansible-playbook \
		-i ./ansible/inventories/$(inventory)/inventory.yml \
		--check \
		$(args) \
		ansible/$(playbook).yml

.PHONY: ansible-encrypt
ansible-encrypt:
	ansible-vault encrypt $(file)

.PHONY: ansible-encrypt-all
ansible-encrypt-all:
	parallel -d '\n' -L 1 -P 0 -a vault-files.txt echo -e '\e\[36mEncrypt {}\e\[0m'\; ansible-vault encrypt {}

.PHONY: ansible-decrypt
ansible-decrypt:
	ansible-vault decrypt $(file)

.PHONY: ansible-decrypt-all
ansible-decrypt-all:
	parallel -d '\n' -L 1 -P 0 -a vault-files.txt echo -e '\e\[36mEncrypt {}\e\[0m'\; ansible-vault decrypt {}
