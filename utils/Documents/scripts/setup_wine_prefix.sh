#!/usr/bin/env bash
set -e

# === Config ===
WINEPREFIX="$HOME/.wine"   # Change this if you want a custom prefix
ARCH="win64"               # "win32" if app/game needs 32-bit Wine

echo ">>> Removing old Wine prefix: $WINEPREFIX"
rm -rf "$WINEPREFIX"

echo ">>> Initializing new $ARCH prefix..."
WINEARCH=$ARCH wineboot --init

echo ">>> Installing core fonts..."
winetricks -q corefonts fontsmooth=rgb

echo ">>> Installing Visual C++ runtimes (most used)..."
winetricks -q vcrun2008 vcrun2010 vcrun2013 vcrun2015

echo ">>> Installing DirectX components..."
winetricks -q d3dx9 d3dx10 d3dx11_43 d3dcompiler_43 d3dcompiler_47

# echo ">>> Installing audio & physics libraries..."
# winetricks -q xact physx
#
# echo ">>> Installing DXVK (for Vulkan-based Direct3D translation)..."
# winetricks -q dxvk

echo ">>> Setup complete!"
echo "Your Wine prefix is ready at: $WINEPREFIX"
