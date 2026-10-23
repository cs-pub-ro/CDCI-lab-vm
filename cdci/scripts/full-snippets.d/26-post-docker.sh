#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Docker tweaks for OpenStack VMs

# MTU fix + address pool change for OpenStack VMs
# (the default one is already used in the grid's internal network...)
cat << EOF > /etc/docker/daemon.json
{
  "mtu": 1450,
  "features": {"buildkit": true},
  "default-address-pools": [
    { "base": "10.226.0.0/12", "size": 24 }
  ]
}
EOF

# Fix docker home directory permissions
mkdir -p /home/student/.docker
chown student:student -R /home/student/.docker
chmod 755 -R /home/student/.docker
