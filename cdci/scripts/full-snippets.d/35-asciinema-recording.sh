#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Set up asciinema auto-recording + upload pipeline
# Records all student terminal sessions and uploads .cast files
# to a collection server for AI tutor training data.

ASCIINEMA_FILES="$(sh_get_script_path)/../files/asciinema"

sh_log_info "Setting up asciinema recording pipeline..."

# Recording directory (world-writable so student can create files)
mkdir -p /var/log/asciinema
chmod 777 /var/log/asciinema

# Auto-record on student login
install -m 644 "$ASCIINEMA_FILES/asciinema-record.sh" /etc/profile.d/

# SSH key for append-only uploads
mkdir -p /etc/asciinema
install -m 600 "$ASCIINEMA_FILES/upload_key" /etc/asciinema/
install -m 644 "$ASCIINEMA_FILES/upload_key.pub" /etc/asciinema/

# Upload script
install -m 755 "$ASCIINEMA_FILES/asciinema-upload.sh" /usr/local/bin/

# Systemd timer (every 10 min) + shutdown hook
install -m 644 "$ASCIINEMA_FILES/asciinema-upload.service" /etc/systemd/system/
install -m 644 "$ASCIINEMA_FILES/asciinema-upload.timer" /etc/systemd/system/
install -m 644 "$ASCIINEMA_FILES/asciinema-shutdown.service" /etc/systemd/system/
systemctl enable asciinema-upload.timer
systemctl enable asciinema-shutdown.service

sh_log_info "Asciinema recording pipeline installed."
sh_log_info "Public key for server authorized_keys:"
cat /etc/asciinema/upload_key.pub
