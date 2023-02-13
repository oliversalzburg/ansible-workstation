age.agekey:
	age-keygen -o age.agekey
	mkdir --parents ~/.config/sops/age
	cat age.agekey >> ~/.config/sops/age/keys.txt

requirements:
	cd provision/ansible; pip3 install -r requirements.txt
	cd provision/ansible; ansible-galaxy install -r roles/requirements.yml

init:
	cd provision/ansible; ansible-playbook site.yml --vault-password-file vault-password-file

init-container:
	cd provision/ansible; ansible-playbook playbooks/10_init-container.yml --vault-password-file vault-password-file
init-laptop:
	cd provision/ansible; ansible-playbook playbooks/10_init-laptop.yml --vault-password-file vault-password-file
init-workstation:
	cd provision/ansible; ansible-playbook playbooks/10_init-workstation.yml --vault-password-file vault-password-file

init-localhost: requirements
	cd provision/ansible; ansible localhost --module-name include_role --args name=all --vault-password-file vault-password-file
