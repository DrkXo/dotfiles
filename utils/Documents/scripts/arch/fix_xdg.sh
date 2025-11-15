#!/usr/bin/env bash
# 🐧 Fix GTK Icon & WebKit2 Crashes on Arch Linux
# This script fixes XDG_DATA_DIRS issues for GTK/AppImages/WebKit2

set -e

# --- Backup current /etc/environment ---
ENV_FILE="/etc/environment"
BACKUP_FILE="/etc/environment.backup.$(date +%Y%m%d%H%M%S)"
if [ -f "$ENV_FILE" ]; then
    echo "[*] Backing up current /etc/environment to $BACKUP_FILE"
    sudo cp "$ENV_FILE" "$BACKUP_FILE"
else
    echo "[*] No /etc/environment file found, creating a new one"
    sudo touch "$ENV_FILE"
fi

# --- Temporary fix for current session ---
echo "[*] Applying temporary fix for current session"
export XDG_DATA_DIRS="/usr/local/share:/usr/share:$HOME/.local/share"
echo "Current XDG_DATA_DIRS: $XDG_DATA_DIRS"

# --- Permanent fix ---
# Remove existing XDG_DATA_DIRS lines
sudo sed -i '/^XDG_DATA_DIRS/d' "$ENV_FILE"
# Add correct XDG_DATA_DIRS
echo "[*] Setting permanent XDG_DATA_DIRS in $ENV_FILE"
echo "XDG_DATA_DIRS=/usr/local/share:/usr/share:$HOME/.local/share" | sudo tee -a "$ENV_FILE"

echo "[✔] Permanent fix applied. Please reboot your system to apply changes globally."
