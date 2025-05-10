## Install Template VM

```shell
sudo virt-install \
    --name debian-template \
    --vcpus 2 \
    --memory 4096 \
    --cdrom /home/oliver/Downloads/debian-12.10.0-amd64-netinst.iso \
    --disk size=5 \
    --os-variant debian12
```

## Export Guest XML Manifest

```shell
sudo virsh dumpxml debian-template > provision/ansible/roles/kvm_up/templates/debian-template.xml.j2
```
