#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Containernet + Open vSwitch installation

sh_log_info "Installing Containernet + Open vSwitch..."

# Install OVS
pkg_install openvswitch-switch

# Install Containernet dependencies
pkg_install ansible git aptitude python3-pip python3-setuptools

# Clone and install Containernet
if [[ ! -d /opt/containernet ]]; then
	git clone https://github.com/containernet/containernet.git /opt/containernet
fi
cd /opt/containernet/ansible
# Fix: Ubuntu 26.04 GCC treats -Wincompatible-pointer-types as error;
# OpenFlow source code triggers this in lib/backtrace.c
export CFLAGS="-Wno-error=incompatible-pointer-types -Wno-error=int-conversion -Wno-error=implicit-function-declaration -Wno-error=return-mismatch -include sys/stat.h"
ansible-playbook -i "localhost," -c local install.yml
cd /opt/containernet
# Fix PEP 668: allow pip to install system-wide on Ubuntu 26.04
rm -f /usr/lib/python3.*/EXTERNALLY-MANAGED
make develop

# Verify installation
mn --version || true
