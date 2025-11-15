#!/usr/bin/env bash
#
# Firefox Profile Transfer Script
# Author: drkxo
# Description:
#   Transfers Firefox (or derivative browser) profile data between
#   two installations, preserving history, passwords, tabs, etc.
#

set -euo pipefail

echo "=== Firefox Profile Transfer Utility ==="
echo

# --- Step 1: Ask for profile paths ---
read -rp "Enter the SOURCE profile folder path: " SRC_PROFILE
read -rp "Enter the DESTINATION profile folder path: " DEST_PROFILE

# Expand ~ if used
SRC_PROFILE="${SRC_PROFILE/#\~/$HOME}"
DEST_PROFILE="${DEST_PROFILE/#\~/$HOME}"

# --- Step 2: Validate paths ---
if [[ ! -d "$SRC_PROFILE" ]]; then
    echo "❌ Source profile not found: $SRC_PROFILE"
    exit 1
fi

if [[ ! -d "$DEST_PROFILE" ]]; then
    echo "❌ Destination profile not found: $DEST_PROFILE"
    exit 1
fi

echo
echo "Source:      $SRC_PROFILE"
echo "Destination: $DEST_PROFILE"
echo
read -rp "Proceed with transfer? (This will overwrite files in destination) [y/N]: " confirm
[[ ! "$confirm" =~ ^[Yy]$ ]] && { echo "Aborted."; exit 0; }

# --- Step 3: Backup destination before overwriting ---
BACKUP_DIR="${DEST_PROFILE}_backup_$(date +%Y%m%d_%H%M%S)"
echo "Backing up destination profile to: $BACKUP_DIR"
cp -a "$DEST_PROFILE" "$BACKUP_DIR"
echo "Backup complete."
echo

# --- Step 4: Copy essential Firefox data ---
ESSENTIAL_FILES=(
    "places.sqlite"              # bookmarks + history
    "cookies.sqlite"             # login sessions
    "cert9.db" "key4.db"         # password key material
    "logins.json"                # saved passwords
    "extension-preferences.json"
    "extensions.json"
    "extension-settings.json"
    "extensions"
    "search.json.mozlz4"         # search engine prefs
    "sessionCheckpoints.json"
    "sessionstore.jsonlz4"       # open tabs
    "prefs.js"                   # about:config settings
)

echo "Copying essential files..."
for f in "${ESSENTIAL_FILES[@]}"; do
    if [[ -e "$SRC_PROFILE/$f" ]]; then
        cp -a "$SRC_PROFILE/$f" "$DEST_PROFILE/"
        echo "✔ $f"
    fi
done
echo

# --- Step 5: Optional folders ---
echo "Optional: Copy UI or add-on data"
read -rp "Copy 'storage' and 'chrome' folders? [y/N]: " optcopy
if [[ "$optcopy" =~ ^[Yy]$ ]]; then
    for folder in storage chrome; do
        if [[ -d "$SRC_PROFILE/$folder" ]]; then
            cp -a "$SRC_PROFILE/$folder" "$DEST_PROFILE/"
            echo "✔ $folder/"
        fi
    done
fi

# --- Step 6: Fix compatibility issue ---
if [[ -f "$DEST_PROFILE/compatibility.ini" ]]; then
    mv "$DEST_PROFILE/compatibility.ini" "$DEST_PROFILE/compatibility.ini.bak"
    echo "Moved compatibility.ini → prevents startup error."
fi

# --- Step 7: Done ---
echo
echo "🎉 Transfer complete!"
echo "Destination profile is ready at: $DEST_PROFILE"
echo "Backup stored at: $BACKUP_DIR"
echo
echo "You can now start Firefox (or your browser) with the destination profile."
echo "Example:"
echo "  firefox -P"
echo "  or"
echo "  firefox --profile \"$DEST_PROFILE\""
echo

