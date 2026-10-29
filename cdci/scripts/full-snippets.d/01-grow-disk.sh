#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Grow root partition to fill available disk space (for Packer disk_size resize)

sh_log_info "Growing root partition to fill disk..."

ROOT_DEV=$(findmnt -no SOURCE /)
ROOT_DISK=$(lsblk -ndo PKNAME "$ROOT_DEV")
ROOT_PART=$(echo "$ROOT_DEV" | grep -oP '\d+$')

if [[ -n "$ROOT_DISK" && -n "$ROOT_PART" ]]; then
	growpart "/dev/$ROOT_DISK" "$ROOT_PART" || true
	resize2fs "$ROOT_DEV" || true
	df -h /
fi

