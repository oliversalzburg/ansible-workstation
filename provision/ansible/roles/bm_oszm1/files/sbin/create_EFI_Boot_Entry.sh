#!/usr/bin/env bash
#       /sbin/create_EFI_Boot_Entry.sh v0.2
#       Automatically create an EFI Boot entry.
#
#       (C) 2018+ ©TriMoon™ <https://github.com/TriMoon>
#       ------------------------------------------------
#       License: BY-SA 4.0
#       This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
#       https://creativecommons.org/licenses/by-sa/4.0/
#

# First compose the variables used as arguments:
label='OSZM1 Debian EFI Stub'
loader='\EFI\Debian\vmlinuz' # Use single \'s !
initrd='\EFI\Debian\initrd.img' # Use single \'s !
# Compose default kernel arguments for an EFI-boot
printf -v largs "%s " \
        "root=UUID=$(findmnt -kno UUID /) ro" \
        "rootfstype=$(findmnt -kno FSTYPE /)" \
        "initrd=${initrd}"
# Grab extra kernel arguments from grub2 config.
grub_cmdline=''
if test -f /etc/default/grub; then
        grub_cmdline="$(sed -nE '/^GRUB_CMDLINE_LINUX_DEFAULT=\"/ {s#GRUB_CMDLINE_LINUX_DEFAULT=\"##; s#\"$##; p}' </etc/default/grub)"
fi
# Append extra kernel arguments
if test -n "${grub_cmdline}"; then
        printf -v largs "%s " \
                "${largs%* }" \
                "${grub_cmdline}"
else
        printf -v largs "%s " \
                "${largs%* }" \
                "quiet splash" \
                "add_efi_memmap" \
                "intel_iommu=on" \
                "nvidia-drm.modeset=1"
fi
# echo "${largs%* }"; exit
# Then create the EFI entry:
echo efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "${label}" --loader "${loader}" --unicode "${largs%* }"
efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "${label}" --loader "${loader}" --unicode "${largs%* }"
