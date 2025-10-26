VAULT_FILE=ansible/group_vars/all/vault.yml

vault:
	openssl rand -hex 12 > .vaultpassword
	echo 'db_password: "$(db_pass)"' > $(VAULT_FILE)
	ansible-vault encrypt $(VAULT_FILE) --vault-password-file .vaultpassword