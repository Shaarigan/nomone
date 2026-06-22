#!/usr/bin/env bash
set -Eeuo pipefail

REPO_BASE="https://raw.githubusercontent.com/Shaarigan/nomone/refs/heads/main"

info() { echo -e "\n[INFO] $1"; }
ok()   { echo "[ OK ] $1"; }
warn() { echo "[WARN] $1"; }

download() {
    local file="$1"
    curl -fsSL "$REPO_BASE/$file" -o "$file"
    chmod +x "$file"
}
ask() {
    local prompt="$1"
    read -rp "$prompt [Y/n]: " answer
    [[ "${answer:-Y}" =~ ^[Yy]$ ]]
}

########################################
# Remove Firefox
########################################

info "Removing Firefox (if installed)..."
sudo apt remove -y 'firefox*' || true
sudo apt autoremove -y

########################################
# Update system
########################################

info "Updating system..."
sudo apt update
sudo apt -y upgrade

########################################
# Base packages
########################################

info "Installing base packages..."
sudo apt install -y \
    wget \
    curl \
    git \
    unzip \
    zip \
    ca-certificates \
    apt-transport-https \
    build-essential

########################################
# KDE Plasma
########################################

info "Installing KDE Plasma..."
sudo apt install -y kde-plasma-desktop

########################################
# Timezone
########################################

info "Setting timezone to Europe/Berlin..."
sudo ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
echo "Europe/Berlin" | sudo tee /etc/timezone >/dev/null

########################################
# KDE Lock screen config
########################################

info "Disabling automatic lock screen..."
mkdir -p "$HOME/.config"

cat > "$HOME/.config/kscreenlockerrc" <<EOF
[Daemon]
Autolock=false
LockOnResume=false
Timeout=0
EOF

########################################
# Optional modules
########################################

if ask "Install JetBrains Rider?"; then
    download rider.sh
    bash ./rider.sh
fi

########################################
# Cleanup
########################################

info "Cleaning up..."
sudo apt autoremove -y
sudo apt clean

rm -f debian.sh

echo
echo "Completed!"
date
