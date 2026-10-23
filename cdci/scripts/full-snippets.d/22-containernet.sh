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
ansible-playbook -i "localhost," -c local install.yml
cd /opt/containernet
make develop

# Verify installation
mn --version || true
