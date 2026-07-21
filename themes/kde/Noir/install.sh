#!/bin/bash
#
# Noir KDE Theme - Installer
# Installs all theme components to user space (~/.local/share/)
#

set -e

THEME_NAME="Noir"
LOCAL_SHARE="${HOME}/.local/share"

echo "Installing ${THEME_NAME} KDE Theme..."

# Create directories
mkdir -p "${LOCAL_SHARE}/color-schemes"
mkdir -p "${LOCAL_SHARE}/konsole"
mkdir -p "${LOCAL_SHARE}/plasma/desktoptheme"
mkdir -p "${LOCAL_SHARE}/plasma/look-and-feel"
mkdir -p "${LOCAL_SHARE}/plasma/splash"
mkdir -p "${LOCAL_SHARE}/aurorae"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install color scheme
echo "  Installing color scheme..."
cp "${SCRIPT_DIR}/color-schemes/${THEME_NAME}.colors" "${LOCAL_SHARE}/color-schemes/"

# Install konsole color scheme
echo "  Installing konsole color scheme..."
cp "${SCRIPT_DIR}/konsole/${THEME_NAME}.colorscheme" "${LOCAL_SHARE}/konsole/"

# Install plasma desktop theme
echo "  Installing plasma desktop theme..."
rm -rf "${LOCAL_SHARE}/plasma/desktoptheme/${THEME_NAME}"
cp -r "${SCRIPT_DIR}/plasma/desktoptheme/${THEME_NAME}" "${LOCAL_SHARE}/plasma/desktoptheme/"

# Install look and feel package
echo "  Installing look and feel package..."
rm -rf "${LOCAL_SHARE}/plasma/look-and-feel/${THEME_NAME}"
cp -r "${SCRIPT_DIR}/plasma/look-and-feel/${THEME_NAME}" "${LOCAL_SHARE}/plasma/look-and-feel/"

# Install splash screen
echo "  Installing splash screen..."
rm -rf "${LOCAL_SHARE}/plasma/splash/${THEME_NAME}"
cp -r "${SCRIPT_DIR}/plasma/splash/${THEME_NAME}" "${LOCAL_SHARE}/plasma/splash/"

# Install Aurorae window decoration
echo "  Installing Aurorae window decoration..."
rm -rf "${LOCAL_SHARE}/aurorae/${THEME_NAME}"
cp -r "${SCRIPT_DIR}/aurorae/${THEME_NAME}" "${LOCAL_SHARE}/aurorae/"

echo ""
echo "${THEME_NAME} theme installed successfully!"
echo ""
echo "To apply the theme:"
echo "  1. Open System Settings > Appearance > Global Theme"
echo "  2. Select '${THEME_NAME}'"
echo "  3. Click 'Apply'"
echo ""
echo "Or apply individual components:"
echo "  - Color Scheme: System Settings > Colors"
echo "  - Window Decoration: System Settings > Window Decorations"
echo "  - Splash Screen: System Settings > Splash Screen"
