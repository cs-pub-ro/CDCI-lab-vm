#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# VM network configuration

# Change hostname to cdci-vm
if [[ "$(hostname)" != "cdci-vm" ]]; then
	hostnamectl set-hostname cdci-vm
	sed -i "s/^127.0.1.1\s.*/127.0.1.1       cdci-vm/g" /etc/hosts
fi
