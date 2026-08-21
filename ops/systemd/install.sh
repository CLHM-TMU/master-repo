#!/usr/bin/env bash
# Installs the ssh/tailscaled OOM-protection drop-ins from this directory into
# /etc/systemd/system/ and reloads systemd. Requires root.
#
# Restarting the services is NOT done automatically here — OOMScoreAdjust and
# MemoryMin only take effect for a unit the next time systemd starts it, so
# the protection won't be live until you restart (or reboot). Do that
# deliberately, on your own terms:
#   sudo systemctl restart tailscaled.service   # brief reconnect, auto-resumes
#   sudo systemctl restart ssh.service          # existing sessions are not killed,
#                                                # but do this from a console you can
#                                                # recover if you're unsure
#
# Usage: sudo ops/systemd/install.sh
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Run this with sudo." >&2
    exit 1
fi

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install -d -m 755 /etc/systemd/system/ssh.service.d /etc/systemd/system/tailscaled.service.d
install -m 644 "$SRC_DIR/ssh.service.d/override.conf" /etc/systemd/system/ssh.service.d/override.conf
install -m 644 "$SRC_DIR/tailscaled.service.d/override.conf" /etc/systemd/system/tailscaled.service.d/override.conf

systemctl daemon-reload

echo "Installed. Restart the services when ready to activate (see comments at the top of this script)."
