VAULT_FILE=ansible/group_vars/all/vault.yml
VAULT_PASS=--vault-password-file .vaultpassword

install:
	ansible-galaxy install -r ansible/requirements.yml

vault:
	openssl rand -hex 12 > .vaultpassword
	echo 'db_password: "$(db_pass)"' > $(VAULT_FILE)
	ansible-vault encrypt $(VAULT_FILE) --vault-password-file .vaultpassword

bootstrap:
	ansible-playbook ansible/bootstrap.yml -u root

deploy:
	ansible-playbook ansible/deploy.yml $(VAULT_PASS)

deploy-db:
	ansible-playbook ansible/deploy.yml $(VAULT_PASS) --tags db

deploy-api:
	ansible-playbook ansible/deploy.yml $(VAULT_PASS) --tags api

deploy-proxy:
	ansible-playbook ansible/deploy.yml $(VAULT_PASS) --tags proxy
