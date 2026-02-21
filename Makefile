requirements: .venv/built
.venv: .venv/built
.venv/built: requirements.txt provision/ansible/requirements.yml
	python3 -m venv .venv
	. .venv/bin/activate && pip install -r requirements.txt
	. .venv/bin/activate && cd provision/ansible && ansible-galaxy collection install -r requirements.yml -p ./collections
	touch .venv/built

clean:
	rm --force --recursive .venv

lint: requirements
	. .venv/bin/activate && cd provision/ansible && ansible-lint

age.agekey:
	age-keygen -o age.agekey
	mkdir --parents ~/.config/sops/age
	cat age.agekey >> ~/.config/sops/age/keys.txt

apt-upgrade: requirements
	cd provision/ansible; ../../.venv/bin/ansible-playbook apt-upgrade.yml

init: requirements
	cd provision/ansible; ../../.venv/bin/ansible-playbook site.yml

init-canyon: requirements
	cd provision/ansible; ../../.venv/bin/ansible-playbook site.yml --limit oszm1.labnet
init-container: requirements
	cd provision/ansible; ../../.venv/bin/ansible-playbook site.yml --limit container.labnet
init-laptop: requirements
	cd provision/ansible; ../../.venv/bin/ansible-playbook site.yml --limit laptop.labnet
init-fireeye: requirements
	cd provision/ansible; ../../.venv/bin/ansible-playbook site.yml --limit fireeye.labnet
init-workstation: requirements
	cd provision/ansible; ../../.venv/bin/ansible-playbook site.yml --limit workstation.labnet

init-localhost: requirements
	. .venv/bin/activate && cd provision/ansible && ansible localhost --module-name include_role --args name=all

update: requirements
	. .venv/bin/activate && cd provision/ansible && ansible-playbook roles.yml
update-check: requirements
	. .venv/bin/activate && cd provision/ansible && ansible-playbook roles.yml --check --diff

update-canyon: requirements
	cd provision/ansible; ../../.venv/bin/ansible-playbook roles.yml --limit oszm1.labnet
update-container: requirements
	cd provision/ansible; ../../.venv/bin/ansible-playbook roles.yml --limit container.labnet
update-fireeye: requirements
	cd provision/ansible; ../../.venv/bin/ansible-playbook roles.yml --limit fireeye.labnet
update-workstation: requirements
	cd provision/ansible; ../../.venv/bin/ansible-playbook roles.yml --limit workstation.labnet
