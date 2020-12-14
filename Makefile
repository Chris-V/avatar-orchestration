ifndef inventory
override inventory = staging
endif
ifndef playbook
override playbook = all
endif

.PHONY: prepare
prepare:
	./prepare.sh

.PHONY: installer
installer:
	sudo ./installer/make-iso.sh

.PHONY: lint
lint:
	ansible-lint ansible/all.yml

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
		--check
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
