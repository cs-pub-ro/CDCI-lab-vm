#!/bin/bash
# Upload finished asciinema recordings to collection server
# Only uploads .cast files not currently being written (active sessions skipped)

UPLOAD_KEY="/etc/asciinema/upload_key"
UPLOAD_USER="asciinema"
UPLOAD_HOST="10.9.4.86"
CAST_DIR="/var/log/asciinema"
LOCK="/var/run/asciinema-upload.lock"

# Bail if no key or no server
[ -f "$UPLOAD_KEY" ] || exit 0

# Prevent concurrent uploads
exec 200>"$LOCK"
flock -n 200 || exit 0

for cast in "$CAST_DIR"/*.cast; do
    [ -f "$cast" ] || continue
    # Skip files still being recorded
    if fuser "$cast" &>/dev/null; then
        continue
    fi
    # Upload and remove on success
    rsync -az -e "ssh -i $UPLOAD_KEY -o StrictHostKeyChecking=accept-new -o BatchMode=yes -o ConnectTimeout=5" \
        "$cast" "${UPLOAD_USER}@${UPLOAD_HOST}:/" \
        && rm -f "$cast"
done
