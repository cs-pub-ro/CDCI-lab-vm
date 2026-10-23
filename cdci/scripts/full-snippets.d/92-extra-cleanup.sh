#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# VM post-install cleanup & minimization

sh_log_info "Running VM cleanup & minimization..."

# Remove apt caches
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/*

# Remove pip caches
rm -rf /root/.cache/pip /home/student/.cache/pip

# Remove temporary build artifacts
rm -rf /tmp/*

# Clear Docker build cache (images are kept!)
docker builder prune -f || true

# Clear logs
journalctl --vacuum-size=10M || true
find /var/log -type f -name "*.gz" -delete 2>/dev/null || true
find /var/log -type f -name "*.1" -delete 2>/dev/null || true
truncate -s 0 /var/log/syslog /var/log/auth.log /var/log/kern.log 2>/dev/null || true

# Remove provisioning scripts and history
if [[ "$VM_DEBUG" != "1" ]]; then
	rm -rf /home/student/install*
	rm -f /home/student/.bash_history
	rm -f /root/.bash_history
	rm -rf /opt/vm-scripts/install-stage*
	rm -rf /opt/vm-scripts/files
	rm -rf /opt/vm-scripts/thirdparty
fi
