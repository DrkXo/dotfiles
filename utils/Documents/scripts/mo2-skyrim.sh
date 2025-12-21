#!/usr/bin/env bash
set -e

############################
# USER CONFIG
############################

STEAM_DIR="$HOME/.local/share/Steam"
STEAM_COMPAT="$STEAM_DIR/steamapps/compatdata"

# Skyrim SE AppID
GAME_APPID="489830"

# Path to extracted MO2
MO2_DIR="$HOME/Games/ModOrganizer2"
MO2_EXE="$MO2_DIR/ModOrganizer.exe"

# Proton to use (folder name in steamapps/common)
PROTON_VERSION="Proton - Experimental"

############################
# ENVIRONMENT
############################

export STEAM_COMPAT_DATA_PATH="$STEAM_COMPAT/$GAME_APPID"
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$STEAM_DIR"

# Mangohud
export MANGOHUD=1
# export MANGOHUD_CONFIG="cpu_temp,gpu_temp,fps,frametime,ram,vram"

# Optional DXVK HUD (comment out if unwanted)
# export DXVK_HUD=compiler,fps

############################
# SANITY CHECKS
############################

if [[ ! -d "$STEAM_COMPAT_DATA_PATH" ]]; then
  echo "❌ Skyrim compatdata folder not found:"
  echo "   $STEAM_COMPAT_DATA_PATH"
  echo "   Launch Skyrim once through Steam first."
  exit 1
fi

if [[ ! -f "$MO2_EXE" ]]; then
  echo "❌ ModOrganizer.exe not found:"
  echo "   $MO2_EXE"
  exit 1
fi

############################
# LAUNCH MO2
############################

echo "🚀 Launching Mod Organizer 2 for Skyrim SE"
echo "📁 Using compatdata: $STEAM_COMPAT_DATA_PATH"
echo "🧪 Proton: $PROTON_VERSION"
echo "📊 Mangohud enabled"

"$STEAM_DIR/steamapps/common/$PROTON_VERSION/proton" run "$MO2_EXE"
