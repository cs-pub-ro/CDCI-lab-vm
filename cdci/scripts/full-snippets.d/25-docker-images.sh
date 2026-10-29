#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Pre-build all CDCI Docker images so students don't waste time

sh_log_info "Pre-building all CDCI Docker images..."

CDCI_LABS_DIR="/home/student/CDCI-labs"

# Clone the labs repo
if [[ ! -d "$CDCI_LABS_DIR/.git" ]]; then
	git clone https://github.com/cs-pub-ro/CDCI-labs.git "$CDCI_LABS_DIR"
	chown -R student:student "$CDCI_LABS_DIR"
fi

# Build cdci_base (includes Snort 3 via multi-stage build)
cd "$CDCI_LABS_DIR/containers"
make -C cdci_base

# Free disk space: remove multi-stage build cache (builder stage ~2GB)
docker builder prune -f --all
docker system prune -f

# Pull official DVWA
docker pull ghcr.io/digininja/dvwa:latest
docker tag ghcr.io/digininja/dvwa:latest dvwa

# Verify all images are present
echo "=== Pre-built Docker images ==="
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
