CDCI_LABVM_VERSION = 2027

# Build output on a Windows-accessible path (QEMU can't access WSL's home dir)
BUILD_DIR = /mnt/d/packer-build

# Point to your ISO directory (use Linux paths if running from WSL)
BASE_ISO_DIR = /mnt/d/iso

# Use Windows QEMU with WHPX acceleration
PACKER_ARGS_EXTRA += -var 'qemu_binary=$(abspath ./qemu-system-x86_64.exe)'
PACKER_ARGS_EXTRA += -var 'qemu_accelerator=whpx'
PACKER_ARGS_EXTRA += -var 'boot_key_interval=100ms'
PACKER_ARGS_EXTRA += -var 'boot_command_wait=20s'

# Run headless (no GUI window, VNC only)
HEADLESS_PACKER = true

# Cloud admin password
CDCI_CLOUD_ADMIN_PASSWORD = cdci-admin-2027
