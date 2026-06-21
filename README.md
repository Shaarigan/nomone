# NOMone Bootstrap

Minimal setup scripts for Debian/Ubuntu inside NOMone Desktop.

## Requirements

Install curl first or run the compact command:

```bash
sudo apt update && sudo apt install -y curl
```

## Run

```bash
sudo apt update && sudo apt install -y curl && bash <(curl -fsSL curl -fsSL https://raw.githubusercontent.com/Shaarigan/nomone/refs/heads/main/setup.sh)
```

You may also run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Shaarigan/nomone/refs/heads/main/setup.sh)
```
**requires curl*

## What it does

- Removes Firefox
- Updates system
- Installs KDE Plasma
- Sets timezone (Europe/Berlin)
- Disables auto screen lock
- Optional installation:
  - .NET SDK
  - JetBrains Rider

## Supported systems

- Debian
- Ubuntu
