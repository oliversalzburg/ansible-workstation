lint:
	cd provision/ansible; ansible-lint

age.agekey:
	age-keygen -o age.agekey
	mkdir --parents ~/.config/sops/age
	cat age.agekey >> ~/.config/sops/age/keys.txt

.venv:
	python3 -m venv .venv

requirements: .venv
	.venv/bin/pip install -r requirements.txt
	.venv/bin/ansible-galaxy install -r provision/ansible/roles/requirements.yml

init: requirements
	cd provision/ansible; ../../.venv/bin/ansible-playbook site.yml

init-canyon: requirements
	cd provision/ansible; ../../.venv/bin/ansible-playbook site.yml --limit canyon.labnet
init-container: requirements
	cd provision/ansible; ../../.venv/bin/ansible-playbook site.yml --limit container.labnet
init-laptop: requirements
	cd provision/ansible; ../../.venv/bin/ansible-playbook site.yml --limit laptop.labnet
init-workstation: requirements
	cd provision/ansible; ../../.venv/bin/ansible-playbook site.yml --limit workstation.labnet

init-localhost: requirements
	cd provision/ansible; ../../.venv/bin/ansible localhost --module-name include_role --args name=all

sandbox:
	cd provision/terraform; terraform init; terraform apply -var id_ed25519_pub=${HOME}/.ssh/id_ed25519.pub
