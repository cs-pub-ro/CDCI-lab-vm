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

# Build all container images using the existing Makefile
cd "$CDCI_LABS_DIR/containers"
make containers

# Verify all images are present
echo "=== Pre-built Docker images ==="
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
