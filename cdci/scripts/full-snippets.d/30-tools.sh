#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Install CDCI lab tools

sh_log_info "Installing CDCI tools..."

# terminal utilities
pkg_install --no-install-recommends tmux vim-nox nano bash-completion less \
	pciutils usbutils sysstat

# network utilities (useful for lab debugging)
pkg_install --no-install-recommends nmap tcpdump traceroute dnsutils \
	netcat-openbsd wget curl

# python development
pkg_install --no-install-recommends \
	python3 python3-venv python3-pip python3-setuptools

# build essentials (in case students need to compile)
pkg_install --no-install-recommends build-essential
