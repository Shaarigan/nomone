#!/usr/bin/env bash
set -Eeuo pipefail

REPO_BASE="https://raw.githubusercontent.com/shaarigan/nomone/main"

info() { echo -e "\n[INFO] $1"; }
ok()   { echo "[ OK ] $1"; }
warn() { echo "[WARN] $1"; }

download() {
    local file="$1"
    curl -fsSL "$REPO_BASE/$file" -o "$file"
    chmod +x "$file"
}

info "Checking distribution..."

source /etc/os-release

case "$ID" in
    debian|ubuntu)
        info "Supported distribution detected: $PRETTY_NAME"

        info "Setup configuration..."
        download debian.sh
        bash ./debian.sh
        ;;
    *)
        warn "Unsupported Distribution: $ID"
        exit 1
        ;;
esac