#!/usr/bin/env bash
# 🎮 KDE Service Menu: Wine GPU Selector with MangoHud
# Adds right-click menu options to run Windows executables with different GPUs

set -euo pipefail

# Configuration
SERVICE_DIR="${HOME}/.local/share/kio/servicemenus"
SERVICE_FILE="${SERVICE_DIR}/wine_gpu_selector.desktop"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
print_info() {
    echo -e "${BLUE}[ℹ]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✔]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

print_error() {
    echo -e "${RED}[✖]${NC} $1"
}

# Check if required commands exist
check_dependencies() {
    local missing_deps=()

    for cmd in wine mangohud; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        print_info "Install them with: sudo pacman -S wine mangohud"
        exit 1
    fi
}

# Create service menu directory
create_directory() {
    if [ ! -d "$SERVICE_DIR" ]; then
        mkdir -p "$SERVICE_DIR"
        print_success "Created directory: $SERVICE_DIR"
    else
        print_info "Directory already exists: $SERVICE_DIR"
    fi
}

# Install the service menu
install_service_menu() {
    cat > "$SERVICE_FILE" << 'EOF'
[Desktop Entry]
Type=Service
ServiceTypes=KonqPopupMenu/Plugin
MimeType=application/x-ms-dos-executable;application/x-msdownload;application/x-wine-extension-msi
Actions=WineDefault;WineIntelGPU;WineNvidiaGPU;
X-KDE-Priority=TopLevel
Icon=wine

[Desktop Action WineDefault]
Name=Wine + MangoHud (Default GPU)
Icon=wine
Exec=env MANGOHUD=1 wine "%f"

[Desktop Action WineIntelGPU]
Name=Wine + MangoHud (Intel iGPU)
Icon=video-display
Exec=env MANGOHUD=1 __NV_PRIME_RENDER_OFFLOAD=0 __VK_LAYER_NV_optimus=non_NVIDIA __GLX_VENDOR_LIBRARY_NAME=mesa VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json wine "%f"

[Desktop Action WineNvidiaGPU]
Name=Wine + MangoHud (NVIDIA dGPU)
Icon=nvidia
Exec=env MANGOHUD=1 __NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia wine "%f"
EOF

    chmod +x "$SERVICE_FILE"
    print_success "Service menu installed: $SERVICE_FILE"
}

# Refresh KDE service menus
refresh_kde_services() {
    if command -v kbuildsycoca6 &> /dev/null; then
        print_info "Refreshing KDE service menus..."
        kbuildsycoca6 &> /dev/null
        print_success "KDE service cache rebuilt"
    elif command -v kbuildsycoca5 &> /dev/null; then
        print_info "Refreshing KDE service menus..."
        kbuildsycoca5 &> /dev/null
        print_success "KDE service cache rebuilt"
    else
        print_warning "Could not find kbuildsycoca. You may need to restart Dolphin or log out."
    fi
}

# Main installation
main() {
    echo ""
    echo "╔════════════════════════════════════════════════╗"
    echo "║  🎮 Wine GPU Selector Installer for KDE       ║"
    echo "╔════════════════════════════════════════════════╝"
    echo ""

    print_info "Checking dependencies..."
    check_dependencies

    print_info "Creating service menu directory..."
    create_directory

    print_info "Installing service menu..."
    install_service_menu

    print_info "Refreshing KDE services..."
    refresh_kde_services

    echo ""
    print_success "Installation complete!"
    echo ""
    echo "You can now right-click any .exe file in Dolphin and choose:"
    echo "  • Wine + MangoHud (Default GPU)"
    echo "  • Wine + MangoHud (Intel iGPU)"
    echo "  • Wine + MangoHud (NVIDIA dGPU)"
    echo ""
    print_info "If the menu doesn't appear, try:"
    echo "  1. Restart Dolphin (Ctrl+Q, then reopen)"
    echo "  2. Or log out and back in"
    echo ""
}

main "$@"
