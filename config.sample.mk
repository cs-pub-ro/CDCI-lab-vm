# Sample VM build script config
# also check out framework/config.default.mk for all variables.

# Lab VM edition
CDCI_LABVM_VERSION = 2027

# Base .iso images dir
BASE_ISO_DIR ?= $(HOME)/Downloads/iso

# E.g., move build output (VM destination) directory to an external drive
#BUILD_DIR ?= /media/myssd/tmp/packer

# Preload VM with SSH keys (must be absolute)
#VM_AUTHORIZED_KEYS = $(abspath dist/authorized_keys)

# Password for cloud VM's console
#CDCI_CLOUD_ADMIN_PASSWORD=cdcirullz  # change this

## WSL / Windows QEMU setup (uncomment if building from WSL)
## Uses the included wrapper script that translates WSL paths for Windows QEMU
#BUILD_DIR = /mnt/d/packer-build
#BASE_ISO_DIR = /mnt/d/iso
#PACKER_ARGS_EXTRA += -var 'qemu_binary=$(abspath ./qemu-system-x86_64.exe)'
#PACKER_ARGS_EXTRA += -var 'qemu_accelerator=whpx'
#HEADLESS_PACKER = true
