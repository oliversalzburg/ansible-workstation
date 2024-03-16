age.agekey:
	age-keygen -o age.agekey
	mkdir --parents ~/.config/sops/age
	cat age.agekey >> ~/.config/sops/age/keys.txt

requirements:
	cd provision/ansible; pipx runpip ansible install -r requirements.txt
	cd provision/ansible; ansible-galaxy install -r roles/requirements.yml

init: requirements
	cd provision/ansible; ansible-playbook site.yml

init-canyon: requirements
	cd provision/ansible; ansible-playbook site.yml --limit canyon
update-canyon: requirements
	cd provision/ansible; ansible-playbook playbooks/10_init-canyon.yml
init-container: requirements
	cd provision/ansible; ansible-playbook site.yml --limit container
update-container: requirements
	cd provision/ansible; ansible-playbook playbooks/10_init-container.yml
init-laptop: requirements
	cd provision/ansible; ansible-playbook site.yml --limit laptop
init-workstation: requirements
	cd provision/ansible; ansible-playbook site.yml --limit workstation
update-workstation: requirements
	cd provision/ansible; ansible-playbook playbooks/10_init-workstation.yml

init-localhost: requirements
	cd provision/ansible; ansible localhost --module-name include_role --args name=all

sandbox:
	cd provision/terraform; terraform init; terraform apply -var id_ed25519_pub=${HOME}/.ssh/id_ed25519.pub
