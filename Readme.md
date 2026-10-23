# CDCI Lab virtual machine source code

This repository contains the CDCI Lab VM generation scripts, based on
[LabVM Framework](https://github.com/cs-pub-ro/labvm-framework)
(automated using `qemu` and Packer).

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
```

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

The VM comes with all CDCI lab Docker images pre-built:

| Image | Used by |
|---|---|
| `cdci-base` | Shared base for all lab containers |
| `kali` | lab03, lab04, lab06 (attacker) |
| `lab03/dnsserver` | lab03 (DNS server) |
| `lab03/iot` | lab03 (IoT Flask app) |
| `lab03/dhcpserver` | lab03 (DHCP/dnsmasq) |
| `dvwa` | lab03 (Damn Vulnerable Web App) |
| `lab05/crypto` | lab05 (crypto tools) |
| `lab06/exfiltration` | lab06 (tunneling tools) |
| `lab07/snort` | lab07 (Snort 3 IDS) |
| `exam_docker` | lab07 (exam environment) |

