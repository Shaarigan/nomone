#!/usr/bin/env bash
set -Eeuo pipefail

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
info https://dot.net/v1/dotnet-install.sh
curl -fsSL https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh
chmod +x dotnet-install.sh

info "Installing .NET 8 SDK..."
sudo mkdir -p "$DOTNET_ROOT"
sudo ./dotnet-install.sh \
    --channel 8.0 \
    --install-dir "$DOTNET_ROOT"

info "Creating symlink..."

sudo ln -sf $DOTNET_ROOT/dotnet /usr/local/bin/dotnet

########################################
# Cleanup
########################################

info "Cleaning up..."
rm -f dotnet-install.sh

#Workaround for .Net GC Heap error on proot environment

#export DOTNET_ROOT=/usr/share/dotnet
export DOTNET_GCHeapHardLimit=1C0000000

echo
dotnet --info

########################################
# Install Rider
########################################

info "Fetching package..."
info "https://download.jetbrains.com/rider/JetBrains.Rider-$RIDER_VERSION-aarch64.tar.gz"
curl -fsSL "https://download.jetbrains.com/rider/JetBrains.Rider-$RIDER_VERSION-aarch64.tar.gz" -o rider.tar.gz

info "Installing Jetbrains Rider..."
RIDER_DIR="JetBrains Rider-$RIDER_VERSION"
sudo tar -xzf rider.tar.gz -C /opt

sudo mv "/opt/$RIDER_DIR" "/opt/JetBrains Rider"
sudo ln -sf "/opt/JetBrains Rider/bin/rider.sh" /usr/local/bin/rider

########################################
# Cleanup
########################################

info "Cleaning up..."
rm -f rider.tar.gz
rm -f rider.sh

echo
echo "Completed!"