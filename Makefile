age.agekey:
	age-keygen -o age.agekey
	mkdir --parents ~/.config/sops/age
	cat age.agekey >> ~/.config/sops/age/keys.txt

requirements:
	cd provision/ansible; pip3 install -r requirements.txt
	cd provision/ansible; ansible-galaxy install -r roles/requirements.yml

init: requirements
	cd provision/ansible; ansible-playbook site.yml

init-container: requirements
	cd provision/ansible; ansible-playbook playbooks/10_init-container.yml
init-laptop: requirements
	cd provision/ansible; ansible-playbook playbooks/10_init-laptop.yml
init-workstation: requirements
	cd provision/ansible; ansible-playbook playbooks/10_init-workstation.yml

init-localhost: requirements
	cd provision/ansible; ansible localhost --module-name include_role --args name=all
