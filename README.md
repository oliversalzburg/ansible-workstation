# ansible-workstation

Assumes Debian, often accepts Ubuntu.

## Getting Started

You have a new machine. Congratulations.

Bootstrap it with the Debian "Netinst" minimal installation image. For example:

-   <https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.6.0-amd64-netinst.iso>

If you need a Windows tool to put this on a USB key, [Rufus](https://rufus.ie/en/) in DD mode is still perfectly fine. If you have a machine with stupid hardware (which you probably have), ensure to use an image with **proprietary firmware included**, such as:

-   <https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current/amd64/iso-cd/firmware-11.6.0-amd64-netinst.iso>

Install `openssh-server`, run `ip a` and take note of the IP address.

When provisioning a new machine, you need an **Ansible control node**. You can bring this up at any time on any machine on your network and tear it down whenever you want. It is only required for play execution.

### Provision Control Node

We will assume you are working on a control node, as provisioned through this framework. If you don't have a control node, bring it up with `./up-ansible-cn` and follow instructions. If you want to provision a standalone node, that node will also be your control node.

### Provision Remote Node

1. Ensure `openssh-server` is installed and running on your remote node.
1. Copy your SSH key to the remote node:
    ```shell
    ssh-copy-id -i /home/oliver/.ssh/id_ed25519 192.168.12.19
    ```
1. Register the node in your inventory. The `inventory` is created in the folder where you provisioned your control node. If you lost it, provision a new control node.

    The default inventory contains an `example` host, which you can modify and use, or you can add entirely new host entries here. We will assume you're using the `example` host and have adjusted it appropriately.

## Regular operations

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

### Apply role on target

```shell
cd provision/ansible
ansible localhost --module-name ansible.builtin.include_role --args name=docker-pihole
```

### Apply task on target

```shell
cd provision/ansible
ansible localhost --module-name ansible.builtin.include_tasks --args roles/all/tasks/l10n.yml
```
