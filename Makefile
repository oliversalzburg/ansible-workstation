age.agekey:
	age-keygen --output age.agekey
	mkdir --parents ~/.config/sops/age
	cat age.agekey >> ~/.config/sops/age/keys.txt

init:
	ansible-playbook provision/ansible/init.yml --vault-password-file provision/ansible/vault-password-file

init-cluster: age.agekey
	ansible-playbook provision/ansible/init-cluster.yml --vault-password-file provision/ansible/vault-password-file
	cat age.agekey | kubectl -n flux-system create secret generic sops-age --from-file=age.agekey=/dev/stdin
	kubectl apply --kustomize cluster/flux/flux-system/

reconcile:
	flux reconcile -n flux-system source git flux-cluster
	flux reconcile -n flux-system kustomization flux-cluster
