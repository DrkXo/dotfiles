#!/usr/bin/env bash
# 🛠 KDE Service Menu: Run Windows EXE with Wine + MangoHud

set -e

SERVICE_DIR="$HOME/.local/share/kio/servicemenus"
SERVICE_FILE="$SERVICE_DIR/run_with_mangohud.desktop"

# Create directory if it doesn't exist
mkdir -p "$SERVICE_DIR"
echo "[*] Created directory $SERVICE_DIR (if it didn't exist)"

# Write the .desktop file
cat > "$SERVICE_FILE" << 'EOF'
[Desktop Entry]
Type=Service
ServiceTypes=KonqPopupMenu/Plugin
MimeType=application/x-ms-dos-executable;application/x-msdownload
Actions=RunWithMangoHud;
X-KDE-Priority=TopLevel
Icon=wine

[Desktop Action RunWithMangoHud]
Name=Run with Wine + MangoHud
Icon=wine
Exec=env MANGOHUD=1 wine "%f"
EOF

chmod +x "$SERVICE_FILE"

echo "[✔] Service menu created at $SERVICE_FILE"
echo "[*] You may need to restart Dolphin or log out and back in for it to appear"
