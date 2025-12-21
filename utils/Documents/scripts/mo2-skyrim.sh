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



############################
# PATHS
############################

SKYRIM_DIR="$STEAM_DIR/steamapps/common/Skyrim Special Edition"
PROTON_BIN="$STEAM_DIR/steamapps/common/$PROTON_VERSION/proton"

############################
# SANITY CHECK
############################

if [[ ! -d "$SKYRIM_DIR" ]]; then
  echo "❌ Skyrim SE directory not found:"
  echo "   $SKYRIM_DIR"
  exit 1
fi

############################
# LAUNCH MO2
############################

echo "🚀 Launching Mod Organizer 2 for Skyrim SE"
echo "📁 Working dir: $SKYRIM_DIR"
echo "📁 Using compatdata: $STEAM_COMPAT_DATA_PATH"
echo "🧪 Proton: $PROTON_VERSION"
echo "📊 Mangohud enabled"

cd "$SKYRIM_DIR"

"$PROTON_BIN" run "$MO2_EXE"

############################
# LAUNCH MO2
############################

echo "🚀 Launching Mod Organizer 2 for Skyrim SE"
echo "📁 Using compatdata: $STEAM_COMPAT_DATA_PATH"
echo "🧪 Proton: $PROTON_VERSION"
echo "📊 Mangohud enabled"

"$STEAM_DIR/steamapps/common/$PROTON_VERSION/proton" run "$MO2_EXE"
