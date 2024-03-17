# ansible-workstation

Assumes Debian, often accepts Ubuntu.

## Getting Started

You have a new machine. Congratulations.

Bootstrap it with the Debian "Netinst" minimal installation image. For example:

-   <https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.1.0-amd64-netinst.iso>

If you need a Windows tool to put this on a USB key, [Rufus](https://rufus.ie/en/) in DD mode is still perfectly fine.

Install `openssh-server`, run `ip a` and take note of the IP address.

When provisioning a new machine, you need an **Ansible control node**. You can bring this up at any time on any machine on your network and tear it down whenever you want. It is only required for play execution.

### Provision Control Node - Quick Start

We will assume you are working on a control node, as provisioned through this framework. If you don't have a control node, bring it up with `./up-ansible-cn` and follow instructions. If you want to provision a standalone node, that node will also be your control node.

1. Clone this repository. If you don't have `git`, you might want to run the `up-bootstrap` script.

    1. Grab the bootstrap script. `wget` should be installed as part of the standard system utilities. If you don't have it, install it with `apt install wget`.

        ```shell
        wget https://raw.githubusercontent.com/oliversalzburg/ansible-workstation/main/up-bootstrap
        ```

    1. Run the bootstrap script:

        ```shell
        bash up-bootstrap
        ```

    1. Clone this repository:

        ```shell
        git clone https://github.com/oliversalzburg/ansible-workstation.git
        ```

1. Prepare the node as a control now:

    ```shell
    cd ansible-workstation
    bash up-ansible-cn
    ```

### Provision Remote Node

1. Ensure `openssh-server` is installed and running on your remote node.

1. Copy your SSH key to the remote node:

    ```shell
    ssh-copy-id -i $HOME/.ssh/id_ed25519 192.168.12.19
    ```

1. Register the node in your inventory.

    The default inventory is located `provision/ansible/inventories/lab`.

## Regular operations

### Provision sandbox

```shell
cd provision/terraform
terraform init
AWS_PROFILE=sandbox terraform apply -var id_ed25519_pub=$HOME/.ssh/id_ed25519.pub
```

### Destroy sandbox

```shell
cd provision/terraform
AWS_PROFILE=sandbox terraform destroy -var id_ed25519_pub=$HOME/.ssh/id_ed25519.pub
```

### Update site

```shell
cd provision/ansible
ansible-playbook site.yml
```

### Update single node

```shell
cd provision/ansible
ansible-playbook site.yml --limit laptop
```

### Apply playbook on node

```shell
cd provision/ansible
ansible-playbook playbooks/00_init-all.yml --limit laptop
```

#### When node not in the inventory

_Usually not helpful, as node is missing `group_vars`._

```shell
cd provision/ansible
ansible-playbook playbooks/00_init-all.yml --inventory admin@<ip_address>, --extra-vars "ansible_user=admin"
```

### Apply role on node

```shell
cd provision/ansible
ansible localhost --module-name ansible.builtin.include_role --args name=podman-pihole
```

#### When node not in the inventory

_Usually not helpful, as node is missing `group_vars`._

```shell
cd provision/ansible
ansible all --inventory admin@<ip_address>, --module-name ansible.builtin.include_role --args name=all --extra-vars "ansible_user=admin"
```

Notice the trailing `,` after the `<ip_address>`.

### Apply task on node

```shell
cd provision/ansible
ansible localhost --module-name ansible.builtin.include_tasks --args roles/all/tasks/l10n.yml
```
