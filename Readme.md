# CDCI Lab virtual machine source code

This repository contains the CDCI Lab VM generation scripts, based on
[LabVM Framework](https://github.com/cs-pub-ro/labvm-framework)
(automated using `qemu` and Packer).

The lab content (topologies, Docker containers, scripts) lives in the
[CDCI-labs](https://github.com/cs-pub-ro/CDCI-labs) repository, which is
cloned inside the VM during the build.

Requirements:
 - a modern Linux system;
 - basic build tools (make);
 - [Hashicorp's Packer](https://packer.io/);
 - [qemu+kvm](https://qemu.org/);

## Preparation

Download and save a [Ubuntu 26.04 LTS Server
install](https://releases.ubuntu.com/26.04/) iso image.

Optionally, create `config.local.mk`, copy the variables from
[`config.sample.mk`](config.sample.mk) and/or
[`framework/config.default.mk`](https://github.com/cs-pub-ro/labvm-framework/blob/master/config.default.mk)
and edit them to your liking.

You might also want to ensure that packer and qemu are properly installed and
configured.

## Building the VM

The following Makefile goals are available (the build process is usually in this
order):

- `base`: builds a base Ubuntu 26.04 install (required for the VM image);
- `labvm`: builds the Lab VM with all required scripts, Docker images, and config;
- `cloud`: builds (from `labvm` VM) the cloud VM, cleaned up and ready
  for cloud usage (OpenStack);
- `cloud_flatten`: flattens the cloud image into a standalone qcow2
  (removes the backing file reference so it can be uploaded to OpenStack);
- `localvm`: exports the labvm for local VirtualBox / VMware usage;
- `labvm_edit`: easily edit an already built Lab VM (uses the previous
  image as backing snapshot);
- `labvm_commit`: commits the edited VM back to its backing base;
- `[*]_clean`: removes the generated image(s);
- `ssh`: SSH-es into a running Packer VM;

### Quick Start

```sh
# 1. Clone with submodules
git clone --recurse-submodules git@github.com:cs-pub-ro/CDCI-lab-vm.git
cd CDCI-lab-vm

# 2. Create config
cp config.sample.mk config.local.mk
# edit config.local.mk as needed

# 3. Build base (one-time)
make base

# 4. Build lab VM (includes Docker image pre-building)
make labvm

# 5. Build cloud image (for OpenStack)
make cloud

# 6. Flatten the cloud image (standalone qcow2, no backing file)
make cloud_flatten
```

> **Note:** `make cloud` produces an overlay image that references the `labvm`
> image as a backing file. `make cloud_flatten` converts it into a single
> self-contained qcow2 (compressed), which is required for uploading to
> OpenStack.

### OpenStack Upload

```sh
openstack image create \
    --disk-format qcow2 \
    --container-format bare \
    --file CDCI_2027_cloud.qcow2 \
    --property hw_disk_bus=virtio \
    --property hw_vif_model=virtio \
    --property os_type=linux \
    --min-disk 20 --min-ram 4096 \
    --public \
    "CDCI-2027-Lab-VM"
```

## Pre-built Docker Images

The VM comes with all CDCI lab Docker images pre-built (from the
[CDCI-labs](https://github.com/cs-pub-ro/CDCI-labs) `containers/` directory):

| Image | Description | Used by |
|---|---|---|
| `cdci_base` | Ubuntu 26.04 base with networking tools, Snort 3, dnsmasq, BIND9, Flask, etc. | lab03, lab04, lab05, lab06, lab07 |
| `dvwa` | Damn Vulnerable Web App (with MariaDB auto-start) | lab03 |
