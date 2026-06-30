#!/usr/bin/env bash
set -Eeuo pipefail

REPO_BASE="https://raw.githubusercontent.com/Shaarigan/nomone/refs/heads/main"
STARTUP_SCRIPT="/NOMone/startup.sh"

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

if [ -f "$STARTUP_SCRIPT" ]; then
    if ! grep -q 'startplasma-x11 &' "$STARTUP_SCRIPT"; then
        if grep -q '^# Launch desktop,' "$STARTUP_SCRIPT"; then
            if ask "Activate KDE Plasma as the default desktop now?"; then
                sed -i 's|^xcompmgr &$|#xcompmgr \&|' "$STARTUP_SCRIPT"
                sed -i 's|^openbox &$|#openbox \&|' "$STARTUP_SCRIPT"
                sed -i 's|^sh ~/.fehbg$|#sh ~/.fehbg|' "$STARTUP_SCRIPT"
                sed -i 's|^plank &$|#plank \&|' "$STARTUP_SCRIPT"
                sed -i '/^#plank &/a\
startplasma-x11 \&
' "$STARTUP_SCRIPT"
                info "KDE Plasma has been enabled"
            else
                sed -i '/^plank &/a\
#startplasma-x11 \&
' "$STARTUP_SCRIPT"
                info "KDE Plasma launcher added but left disabled"
                info "Uncomment 'startplasma-x11 &' in $STARTUP_SCRIPT to enable Plasma later"
            fi
        else
            warn "Could not patch $STARTUP_SCRIPT: Launch desktop marker not found"
        fi
    else
        info "Plasma launcher already present"
    fi
fi

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
