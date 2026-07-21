#!/bin/bash
#
# Noir KDE Theme - Uninstaller
# Removes all theme components from user space (~/.local/share/)
#

set -e

THEME_NAME="Noir"
LOCAL_SHARE="${HOME}/.local/share"

echo "Uninstalling ${THEME_NAME} KDE Theme..."

# Remove color scheme
if [ -f "${LOCAL_SHARE}/color-schemes/${THEME_NAME}.colors" ]; then
    echo "  Removing color scheme..."
    rm "${LOCAL_SHARE}/color-schemes/${THEME_NAME}.colors"
fi

# Remove konsole color scheme
if [ -f "${LOCAL_SHARE}/konsole/${THEME_NAME}.colorscheme" ]; then
    echo "  Removing konsole color scheme..."
    rm "${LOCAL_SHARE}/konsole/${THEME_NAME}.colorscheme"
fi

# Remove plasma desktop theme
if [ -d "${LOCAL_SHARE}/plasma/desktoptheme/${THEME_NAME}" ]; then
    echo "  Removing plasma desktop theme..."
    rm -rf "${LOCAL_SHARE}/plasma/desktoptheme/${THEME_NAME}"
fi

# Remove look and feel package
if [ -d "${LOCAL_SHARE}/plasma/look-and-feel/${THEME_NAME}" ]; then
    echo "  Removing look and feel package..."
    rm -rf "${LOCAL_SHARE}/plasma/look-and-feel/${THEME_NAME}"
fi

# Remove splash screen
if [ -d "${LOCAL_SHARE}/plasma/splash/${THEME_NAME}" ]; then
    echo "  Removing splash screen..."
    rm -rf "${LOCAL_SHARE}/plasma/splash/${THEME_NAME}"
fi

# Remove Aurorae window decoration
if [ -d "${LOCAL_SHARE}/aurorae/${THEME_NAME}" ]; then
    echo "  Removing Aurorae window decoration..."
    rm -rf "${LOCAL_SHARE}/aurorae/${THEME_NAME}"
fi

echo ""
echo "${THEME_NAME} theme uninstalled successfully!"
echo ""
echo "Note: You may need to switch to a different theme in System Settings"
echo "before logging out to avoid a fallback theme being applied."
