#!/bin/bash
# Auto-record terminal sessions for student user using asciinema
# Installed to /etc/profile.d/ — runs on every interactive login
if [ "$USER" = "student" ] && [ -z "$ASCIINEMA_REC" ] && [[ $- == *i* ]]; then
    export ASCIINEMA_REC=1
    CAST_DIR="/var/log/asciinema"
    mkdir -p "$CAST_DIR" 2>/dev/null
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    CAST_FILE="${CAST_DIR}/session_${TIMESTAMP}_$$.cast"
    exec asciinema rec --idle-time-limit 30 "$CAST_FILE"
fi
