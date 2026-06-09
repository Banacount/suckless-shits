#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# --- Colors for Output ---
NC='\0330m'
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'

log_info()    { echo -e "${BLUE}${BOLD}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}${BOLD}[SUCCESS]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}${BOLD}[WARNING]${NC} $1"; }
log_error()   { echo -e "${RED}${BOLD}[ERROR]${NC} $1"; }

# --- Verification ---
BASE_DIR="/home/excalibur/Documents/suckless-shits"

if [ "$PWD" != "$BASE_DIR" ]; then
    log_warn "Not running from $BASE_DIR. Snapping context to target directory..."
    cd "$BASE_DIR" || { log_error "Could not navigate to $BASE_DIR"; exit 1; }
fi

# --- 1. Install System Dependencies ---
log_info "Updating system and installing base dependencies..."
# Assumes an Arch Linux ecosystem based on your setup tracking.
# Includes core X11 development headers needed to compile dwm/dmenu/st.
sudo pacman -Syu --needed --noconfirm \
    base-devel \
    libx11 \
    libxinerama \
    libxft \
    webkit2gtk \
    xorg-server \
    xorg-xinit \
    picom \
    feh \
    flameshot \
    kitty

# --- 2. Compile & Install Suckless Tools ---
compile_suckless() {
    local dir=$1
    if [ -d "$dir" ]; then
        log_info "Compiling and installing $dir..."
        cd "$dir"
        
        # Clean any previous artifacts safely
        make clean
        
        # Compile and install globally
        sudo make clean install
        
        cd "$BASE_DIR"
        log_success "$dir installed successfully."
    else
        log_warn "Directory $dir not found. Skipping."
    fi
}

# Ordered installation loop
for tool in dmenu dwm st dwmblocks; do
    compile_suckless "$tool"
done

# --- 3. Deploy Configurations & Scripts ---
log_info "Deploying configuration files..."

# Ensure target config directories exist
mkdir -p "$HOME/.config/kitty"
mkdir -p "$HOME/.local/bin"

if [ -d "config_files" ]; then
    cd config_files
    
    # Copy terminal configuration
    if [ -f "kitty.conf" ]; then
        cp kitty.conf "$HOME/.config/kitty/kitty.conf"
        log_info "Kitty config copied."
    fi
    
    # Deploy your helper scripts to user local bin
    for script in add_music.sh lasts.sh shit.sh; do
        if [ -f "$script" ]; then
            cp "$script" "$HOME/.local/bin/$script"
            chmod +x "$HOME/.local/bin/$script"
            log_info "Script $script installed to ~/.local/bin/"
        fi
    fi
    
    # Set up X11 Desktop entry for Display Managers (GDM/LightDM/LY)
    if [ -f "dwm.desktop" ]; then
        log_info "Registering dwm session with display manager..."
        sudo cp dwm.desktop /usr/share/xsessions/
    fi
    
    cd "$BASE_DIR"
else
    log_warn "config_files directory missing. Skipping config copying."
fi

# --- 4. Environment Sanity Check ---
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    log_warn "~/.local/bin is not in your current PATH. Ensure your shell profile maps it."
fi

log_success "Build complete! Restart your X session or display manager to test your new environment."
