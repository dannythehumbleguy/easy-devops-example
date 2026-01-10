VAULT_FILE=ansible/group_vars/all/vault.yml
VAULT_PASS=--vault-password-file .vaultpassword

install:
	ansible-galaxy install -r ansible/requirements.yml

vault:
	openssl rand -hex 12 > .vaultpassword
	echo 'db_password: "$(db_pass)"' > $(VAULT_FILE)
	ansible-vault encrypt $(VAULT_FILE) --vault-password-file .vaultpassword

bootstrap:
	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ansible/bootstrap.yml -i ansible/inventory.ini $(VAULT_PASS) -e "ansible_user=root" -k

deploy:
	ansible-playbook ansible/deploy.yml $(VAULT_PASS) -i ansible/inventory.ini

deploy-db:
	ansible-playbook ansible/deploy.yml $(VAULT_PASS) --tags db -i ansible/inventory.ini

deploy-api:
	ansible-playbook ansible/deploy.yml $(VAULT_PASS) --tags api -i ansible/inventory.ini

deploy-proxy:
	ansible-playbook ansible/deploy.yml $(VAULT_PASS) --tags proxy -i ansible/inventory.ini
