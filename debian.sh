#!/bin/bash

# ======================================
# Automation Script for BSPWM Environment
# ======================================

# ======================================
# Color Configuration
# ======================================

# Text colors
BLACK='\033[1;30m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# ======================================
# Global Variables
# ======================================

USERNAME=$(whoami)
HOME_DIR="/home/${USERNAME}"
CURRENT_DIR=$(pwd)
CONFIG_DIR="${HOME_DIR}/.config"

# ======================================
# Helper Functions
# ======================================

# Function to display the banner
banner() {
    echo -e "${WHITE}╔═══════════════════════════════════════════════╗"
    echo -e "${WHITE}|${CYAN}   ██████╗ ███████╗██████╗ ██╗    ██╗███╗   ███╗${WHITE} |"
    echo -e "${WHITE}|${CYAN}   ██╔══██╗██╔════╝██╔══██╗██║    ██║████╗ ████║${WHITE} |"
    echo -e "${WHITE}|${CYAN}   ██████╔╝███████╗██████╔╝██║ █╗ ██║██╔████╔██║${WHITE} |"
    echo -e "${WHITE}|${CYAN}   ██╔══██╗╚════██║██╔═══╝ ██║███╗██║██║╚██╔╝██║${WHITE} |"
    echo -e "${WHITE}|${CYAN}   ██████╔╝███████║██║     ╚███╔███╔╝██║ ╚═╝ ██║${WHITE} |"
    echo -e "${WHITE}|${CYAN}   ╚═════╝ ╚══════╝╚═╝      ╚══╝╚══╝ ╚═╝     ╚═╝${WHITE} |"
    echo -e "${WHITE}╚═══════════════════════════════════════════════╝"
    echo ""
    echo -e "${WHITE}[${BLUE}i${WHITE}] Automation script for BSPWM environment."
    echo -e "${WHITE}[${BLUE}i${WHITE}] Author: JNJ4M"
    echo ""
    echo -e "${WHITE}[${BLUE}i${WHITE}] Installation will begin shortly."
    echo ""
    sleep 2
    echo -e "${WHITE}[${BLUE}i${WHITE}] Hello ${RED}${USERNAME}${WHITE}, this is the BSPWM installation script for Debian Linux."
    echo ""
}

# Function to prompt for user confirmation
confirm() {
    read -p "$(echo -e "${WHITE}[${BLUE}!${WHITE}] Do you want to continue with the installation? [Y/N]: ${RED}")" -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${WHITE}[${RED}!${WHITE}] Installation cancelled."
        exit 1
    fi
}

# Function to check if a package is installed
is_installed() {
    dpkg -s "$1" &> /dev/null
}

# Function to install a package if not installed
install_package() {
    local package="$1"
    if ! is_installed "$package"; then
        echo -e "${WHITE}[${RED}-${WHITE}] ${package} is not installed. Installing ${package}..."
        sudo apt-get install -y "$package"
    else
        echo -e "${WHITE}[${BLUE}+${WHITE}] ${package} is already installed."
    fi
}

# Function to copy configuration files
copy_config() {
    local source_dir="$1"
    local target_dir="$2"
    echo -e "${WHITE}[${BLUE}+${WHITE}] Installing configuration for $(basename "$target_dir")..."
    rm -rf "$target_dir"
    cp -r "$source_dir" "$target_dir"
}

# Main installation function
install() {
    # Update repositories
    echo -e "${WHITE}[${BLUE}i${WHITE}] Updating repositories..."
    sudo apt-get update -y

    # Packages to install
    local packages=(
        zsh bspwm sxhkd kitty picom neofetch ranger cava polybar rofi
        fonts-firacode fonts-cantarell lxappearance nitrogen lsd i3lock
        flameshot git net-tools xclip xdotool scrub bat tty-clock feh
        pulseaudio-utils lolcat
    )

    # Install packages
    for pkg in "${packages[@]}"; do
        install_package "$pkg"
    done

    # Change default shell to zsh
    if [ "$SHELL" != "/usr/bin/zsh" ]; then
        echo -e "${WHITE}[${BLUE}+${WHITE}] Changing default shell to zsh..."
        chsh -s "$(which zsh)"
    fi

    # Configurations to copy
    local configs=("bspwm" "sxhkd" "kitty" "picom" "neofetch" "ranger" "cava" "polybar")
    for config in "${configs[@]}"; do
        copy_config "${CURRENT_DIR}/.config/${config}" "${CONFIG_DIR}/${config}"
    done

    # Ensure executable permissions for scripts
    chmod +x "${CONFIG_DIR}/bspwm/bspwmrc"
    chmod +x "${CONFIG_DIR}/sxhkd/sxhkdrc"
    find "${CONFIG_DIR}/polybar" -type f -iname "*.sh" -exec chmod +x {} \;

    # Install fonts
    echo -e "${WHITE}[${BLUE}+${WHITE}] Installing fonts..."
    cp -r "${CURRENT_DIR}/.fonts" "${HOME_DIR}/.fonts"
    sudo cp -r "${CURRENT_DIR}/.fonts" "/usr/share/fonts"
    fc-cache -fv

    # Copy themes
    echo -e "${WHITE}[${BLUE}+${WHITE}] Installing themes..."
    cp -r "${CURRENT_DIR}/.themes" "${HOME_DIR}"

    # Ensure executable permissions for theme scripts
    find "${HOME_DIR}/.themes" -type f -iname "*.sh" -exec chmod +x {} \;

    # Copy personal scripts
    echo -e "${WHITE}[${BLUE}+${WHITE}] Installing personal scripts..."
    cp -r "${CURRENT_DIR}/scripts" "${HOME_DIR}"
    find "${HOME_DIR}/scripts" -type f -iname "*.sh" -exec chmod +x {} \;

    # Clone additional repositories
    echo -e "${WHITE}[${BLUE}+${WHITE}] Cloning additional repositories..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${HOME_DIR}/powerlevel10k"
    git clone https://github.com/charitarthchugh/shell-color-scripts.git "${HOME_DIR}/scripts/shell-color-scripts"
    git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME_DIR}/.fzf"
    "${HOME_DIR}/.fzf/install" --all
    git clone https://github.com/pipeseroni/pipes.sh.git "${HOME_DIR}/scripts/pipes.sh"

    # Configure zsh-sudo plugin
    sudo mkdir -p /usr/share/zsh-sudo
    sudo wget -qO /usr/share/zsh-sudo/sudo.plugin.zsh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh

    # Copy zsh configuration files
    echo -e "${WHITE}[${BLUE}+${WHITE}] Configuring Zsh and Powerlevel10k..."
    cp "${CURRENT_DIR}/.zshrc" "${HOME_DIR}/.zshrc"
    cp "${CURRENT_DIR}/.p10k.zsh" "${HOME_DIR}/.p10k.zsh"

    # Completion message
    echo -e "${WHITE}[${GREEN}✓${WHITE}] Installation completed successfully."
    echo -e "${WHITE}[${BLUE}i${WHITE}] Please restart your session to apply the changes."
}

# ======================================
# Script Execution
# ======================================

clear
banner
confirm
install
