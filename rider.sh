#!/usr/bin/env bash
set -Eeuo pipefail

DESKTOP_DIR="$HOME/Desktop"
DOTNET_ROOT="/usr/share/dotnet"
RIDER_VERSION="2026.1.3"

info() { echo -e "\n[INFO] $1"; }
ok()   { echo "[ OK ] $1"; }
warn() { echo "[WARN] $1"; }

########################################
# Install Dependencies
########################################

info "Installing .NET Dependencies..."
sudo apt install -y \
    libc6 \
    libgcc-s1 \
    libstdc++6 \
    zlib1g \
    libicu72 \
    libssl3 \
    libkrb5-3

########################################
# Install .NET
########################################

info "Fetching installer..."
info "https://dot.net/v1/dotnet-install.sh"
curl -fsSL "https://dot.net/v1/dotnet-install.sh" -o dotnet-install.sh
chmod +x dotnet-install.sh

info "Installing .NET 8 SDK..."
sudo mkdir -p "$DOTNET_ROOT"
sudo ./dotnet-install.sh \
    --channel 8.0 \
    --install-dir "$DOTNET_ROOT"

info "Creating symlink..."

sudo ln -sf "$DOTNET_ROOT/dotnet" "/usr/local/bin/dotnet"

########################################
# Cleanup
########################################

info "Cleaning up..."
rm -f dotnet-install.sh

#Workaround for .Net GC Heap error on proot environment
if ! grep -q "DOTNET_GCHeapHardLimit" "$HOME/.bashrc"; then
cat >> "$HOME/.bashrc" <<'EOF'

export DOTNET_GCHeapHardLimit=1C0000000
EOF
fi
export DOTNET_GCHeapHardLimit=1C0000000

echo
dotnet --info

########################################
# Install Rider
########################################

info "Fetching package..."
info "https://download.jetbrains.com/rider/JetBrains.Rider-$RIDER_VERSION-aarch64.tar.gz"
curl -fL# "https://download.jetbrains.com/rider/JetBrains.Rider-$RIDER_VERSION-aarch64.tar.gz" -o rider.tar.gz

info "Installing Jetbrains Rider..."
sudo tar -xzf rider.tar.gz -C /opt

sudo mv "/opt/JetBrains Rider-$RIDER_VERSION" "/opt/JetBrains Rider"
sudo ln -sf "/opt/JetBrains Rider/bin/rider.sh" "/usr/local/bin/rider"

########################################
# Create Desktop Entry
########################################

info "Creating desktop entry..."

mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/jetbrains-rider.desktop" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=JetBrains Rider
Comment=.NET IDE
Exec=env DOTNET_GCHeapHardLimit=1C0000000 "/opt/JetBrains Rider/bin/rider"
Icon=/opt/JetBrains Rider/bin/rider.svg
Terminal=false
Categories=Development;IDE;
StartupNotify=true
StartupWMClass=jetbrains-rider
EOF

chmod 644 "$HOME/.local/share/applications/jetbrains-rider.desktop"
ln -sf "$HOME/.local/share/applications/jetbrains-rider.desktop" \
       "$DESKTOP_DIR/JetBrains Rider.desktop"

########################################
# Cleanup
########################################

info "Cleaning up..."
rm -f rider.tar.gz
rm -f rider.sh

echo
echo "Completed!"