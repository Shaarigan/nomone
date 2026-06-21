# NOMone Bootstrap

Minimal setup scripts for Debian/Ubuntu inside NOMone Desktop.

## Requirements

Install curl first:

```bash
sudo apt install curl
```

## Run

```
bash <(curl -fsSL https://raw.githubusercontent.com/Shaarigan/nomone/refs/heads/main/setup.sh)
```

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
