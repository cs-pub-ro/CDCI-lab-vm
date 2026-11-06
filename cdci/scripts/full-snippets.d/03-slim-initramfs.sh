#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Slim down initramfs for VM use
# Default MODULES=most includes all HDD/FS drivers (~58MB compressed).
# MODULES=dep auto-detects only what's needed (~33MB), so the VM
# can boot with 1GB RAM without OOM during initramfs decompression.
# (Workaround for kernel 7.0.0-43 early-boot memory regression)

sh_log_info "Switching initramfs to MODULES=dep for VM..."

sed -i 's/^MODULES=most/MODULES=dep/' /etc/initramfs-tools/initramfs.conf
update-initramfs -u

ls -lh /boot/initrd.img-*
