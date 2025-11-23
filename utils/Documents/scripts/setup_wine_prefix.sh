#!/usr/bin/env bash
set -e

# === Config ===
WINEPREFIX="${WINEPREFIX:-$HOME/.wine}"  # Use environment variable or default
ARCH="${WINEARCH:-win64}"                 # Use environment variable or default

echo ">>> Removing old Wine prefix: $WINEPREFIX"
rm -rf "$WINEPREFIX"

echo ">>> Initializing new $ARCH prefix..."
# Set WINEARCH and initialize prefix
env WINEARCH="$ARCH" WINEPREFIX="$WINEPREFIX" wineboot -u

echo ">>> Waiting for wineserver to finish initialization..."
env WINEPREFIX="$WINEPREFIX" wineserver -w

echo ">>> Installing core fonts..."
env WINEPREFIX="$WINEPREFIX" winetricks -q corefonts fontsmooth=rgb

echo ">>> Installing Visual C++ runtimes (most used)..."
env WINEPREFIX="$WINEPREFIX" winetricks -q vcrun2008 vcrun2010 vcrun2013 vcrun2015

echo ">>> Installing DirectX components..."
env WINEPREFIX="$WINEPREFIX" winetricks -q d3dx9 d3dx10 d3dx11_43 d3dcompiler_43 d3dcompiler_47

# Optional: Install DXVK for better DirectX 9-11 performance via Vulkan
# Uncomment if you have a Vulkan-capable GPU
echo ">>> Installing DXVK (for Vulkan-based Direct3D translation)..."
env WINEPREFIX="$WINEPREFIX" winetricks -q dxvk

# Optional: Install VKD3D-Proton for DirectX 12 support
echo ">>> Installing VKD3D-Proton (for DirectX 12 support)..."
env WINEPREFIX="$WINEPREFIX" winetricks -q vkd3d

# Optional: Install audio & physics libraries if needed
echo ">>> Installing audio & physics libraries..."
env WINEPREFIX="$WINEPREFIX" winetricks -q xact #  physx

echo ">>> Setup complete!"
echo "Your Wine prefix is ready at: $WINEPREFIX"
echo ""
echo "Architecture: $ARCH"
echo ""
echo "To use this prefix, run: WINEPREFIX='$WINEPREFIX' wine your_app.exe"
