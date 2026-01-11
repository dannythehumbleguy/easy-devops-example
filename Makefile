VAULT_FILE=ansible/group_vars/all/vault.yml
VAULT_PASS=--vault-password-file .vaultpassword

.PHONY: install vault bootstrap deploy deploy-db deploy-api deploy-proxy

install:
	ansible-galaxy install -r ansible/requirements.yml

vault:
	openssl rand -hex 12 > .vaultpassword
	echo 'db_password: "$(db_pass)"' > $(VAULT_FILE)
	ansible-vault encrypt $(VAULT_FILE) --vault-password-file .vaultpassword

bootstrap:
	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ansible/bootstrap.yml -i ansible/inventory.ini $(VAULT_PASS) -e "ansible_user=root" -k

# Полный деплой всего (bootstrap/db/api/proxy в одном запуске)
deploy:
	ansible-playbook ansible/deploy.yml $(VAULT_PASS) -i ansible/inventory.ini

# Деплой только части, ограничиваемся группами хостов
deploy-db:
	ansible-playbook ansible/deploy.yml $(VAULT_PASS) -i ansible/inventory.ini -l db

deploy-api:
	ansible-playbook ansible/deploy.yml $(VAULT_PASS) -i ansible/inventory.ini -l api

deploy-proxy:
	ansible-playbook ansible/deploy.yml $(VAULT_PASS) -i ansible/inventory.ini -l proxy
