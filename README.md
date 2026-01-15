# NixOS and Home Manager Configuration

[![Nix Check](https://github.com/jinglemansweep/nix/actions/workflows/nix-check.yml/badge.svg)](https://github.com/jinglemansweep/nix/actions/workflows/nix-check.yml)

A Nix Flakes-based configuration supporting full NixOS installations and standalone Home Manager environments.

## Quick Start

### Standalone Home Manager (ChromeOS/WSL)

```bash
# Install Nix with Flakes
sh <(curl -L https://nixos.org/nix/install) --daemon
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Clone and install
git clone https://github.com/jinglemansweep/nix.git ~/nix
cd ~/nix
nix run home-manager -- switch --flake .#louis
```

### NixOS (Existing Installation)

```bash
# Clone configuration
git clone https://github.com/jinglemansweep/nix.git ~/nix
cd ~/nix

# Apply configuration
sudo nixos-rebuild switch --flake .#latitude
# or: sudo nixos-rebuild switch --flake .#lounge
# or: sudo nixos-rebuild switch --flake .#dev
# or: sudo nixos-rebuild switch --flake .#docker-runner
```

## Updating

### NixOS

```bash
cd ~/nix
nix flake update
sudo nixos-rebuild switch --flake .#latitude
```

### Standalone Home Manager

```bash
cd ~/nix
nix flake update
home-manager switch --flake .#louis
```

## Directory Structure

```
.
├── .github/workflows/
│   └── nix-check.yml         # Flake check and linting
├── .pre-commit-config.yaml   # Pre-commit hooks
├── flake.nix                 # Main flake entry point
├── flake.lock
├── hosts/                    # NixOS host configurations
│   ├── common/               # Shared NixOS configuration
│   │   ├── default.nix       # Base system configuration
│   │   └── desktop.nix       # Desktop-specific system config
│   ├── dev/                  # Proxmox VM (headless, nix-ld for VS Code Remote SSH)
│   ├── docker-runner/        # Proxmox VM (minimal Docker Swarm runner)
│   ├── latitude/             # Dell Latitude 7420
│   └── lounge/               # HP EliteDesk 800 G2 Mini
├── home/                     # Home Manager entry points
│   ├── common/               # Shared home configuration (SOPS, XDG)
│   ├── docker-runner.nix     # Docker runner (base + docker tools only)
│   ├── nixos.nix             # NixOS desktop (includes desktop modules)
│   ├── server.nix            # NixOS server (shell only)
│   └── standalone.nix        # Standalone (ChromeOS/WSL)
├── modules/
│   ├── nixos/                # NixOS system modules
│   │   ├── desktop/
│   │   │   ├── common.nix    # Shared desktop config, system packages
│   │   │   ├── gnome.nix     # GNOME desktop module
│   │   │   └── sway.nix      # Sway window manager module
│   │   ├── systemd/
│   │   │   ├── default.nix   # Systemd service imports
│   │   │   ├── docker-backup.nix # Docker volume backup service
│   │   │   └── nix-gc.nix    # Automated garbage collection
│   │   ├── mounts.nix        # NFS automounts for Synology NAS
│   │   └── virtualisation.nix # Docker and Podman configuration
│   └── home/                 # Home Manager modules
│       ├── shell/
│       │   ├── base.nix      # Git, tmux, bash, starship, neovim, GPG, SSH
│       │   ├── development.nix # Languages, LSPs, AI CLI, DevOps, database clients
│       │   └── docker.nix    # Container management tools (lazydocker)
│       ├── desktop/
│       │   ├── default.nix   # Alacritty terminal, udiskie, imports
│       │   ├── browsers.nix  # Firefox with extensions and bookmarks
│       │   ├── development.nix # VSCode and Zed editor with extensions
│       │   ├── gnome.nix     # GNOME extensions and dconf settings
│       │   ├── media.nix     # Kodi with NFS media sources
│       │   └── sway.nix      # Sway window manager configuration
│       ├── env.nix           # Environment variable configuration
│       └── secrets.nix       # SOPS secrets with age encryption
├── dotfiles/
│   ├── claude/               # Claude Code configuration
│   │   ├── CLAUDE.md
│   │   ├── commands/
│   │   ├── agents/
│   │   ├── skills/
│   │   ├── settings.json
│   │   └── mcp_settings.json
│   └── direnv/
│       └── direnvrc          # Custom load_secrets helpers
├── secrets/
│   └── secrets.yaml          # Age-encrypted secrets (SOPS)
└── scripts/
    └── partition.sh          # Disk partitioning helper
```

## Included Software

### Shell Tools
bat, btop, borgbackup, delta, eza, fd, fzf, gh, git, github-copilot-cli, htop, imagemagick, jq, keychain, lazydocker, lazygit, ncdu, neofetch, neovim, opentofu, pre-commit, rclone, restic, ripgrep, rsync, screen, starship, terragrunt, tmux, tree, vim, yq

Database clients: psql (PostgreSQL), mysql (MariaDB), redis-cli

### Development
Python 3, Node.js, Go, gcc, gnumake, cmake, pkg-config, autoconf, automake, sqlite

Language servers: nil (Nix), pyright (Python), typescript-language-server, yaml-language-server, terraform-ls, dockerfile-language-server, bash-language-server, vscode-langservers-extracted

AI CLI: claude-code, codex, gemini-cli, opencode

MicroPython/CircuitPython: picocom, esptool, picotool, mpremote, mosquitto

Testing: playwright-driver

### DevOps
AWS CLI, kubectl, helm, k9s, infisical

### Desktop (NixOS only)
Firefox (with uBlock Origin, Bitwarden), Google Chrome, VSCode, Alacritty, LibreOffice, GIMP, Pinta, VLC, mpv, ffmpeg, Kodi, Cura, Thonny, Tiled, Evince, Baobab

## Configuration

### Tmux
- Prefix key: `Ctrl+a`
- Split horizontal: `Prefix + |`
- Split vertical: `Prefix + -`
- Navigate panes: `Alt + Arrow keys`

### Git
- User: Louis King <jinglemansweep@gmail.com>
- Pull strategy: merge (rebase disabled)

### Desktop Environments
GNOME (default) and Sway window manager are available. Select at the login screen.

---

## Advanced Setup

### Fresh NixOS Installation from USB

#### 1. Create Bootable USB

Download the NixOS ISO from [nixos.org](https://nixos.org/download.html).

```bash
# On Linux/macOS (replace /dev/sdX with your USB device)
sudo dd if=nixos-minimal-*.iso of=/dev/sdX bs=4M status=progress conv=fsync
```

#### 2. Boot and Partition

Boot from the USB and run:

```bash
# For UEFI systems with a single disk
sudo parted /dev/nvme0n1 -- mklabel gpt
sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB
sudo parted /dev/nvme0n1 -- set 1 esp on
sudo parted /dev/nvme0n1 -- mkpart primary 512MB -8GB
sudo parted /dev/nvme0n1 -- mkpart primary linux-swap -8GB 100%

# Format partitions
sudo mkfs.fat -F 32 -n boot /dev/nvme0n1p1
sudo mkfs.ext4 -L nixos /dev/nvme0n1p2
sudo mkswap -L swap /dev/nvme0n1p3
```

#### 3. Mount and Install

```bash
# Mount partitions
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
sudo swapon /dev/disk/by-label/swap

# Clone this repository
git clone https://github.com/jinglemansweep/nix.git /tmp/nix

# Install NixOS
sudo nixos-install --flake /tmp/nix#latitude
# or: sudo nixos-install --flake /tmp/nix#lounge

# Set root password when prompted, then reboot
sudo reboot
```

#### 4. Post-Installation

After rebooting:

```bash
# Set user password
sudo passwd louis

# Clone config to home directory for future updates
git clone https://github.com/jinglemansweep/nix.git ~/nix
```

### Adding a New Host

1. Create a new directory under `hosts/`:

```bash
mkdir -p hosts/new-host
```

2. Create `hosts/new-host/default.nix`:

```nix
# Description of new host
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "new-host";

  # Host-specific configuration here
}
```

3. Generate `hardware-configuration.nix` on the target machine:

```bash
nixos-generate-config --show-hardware-config > hosts/new-host/hardware-configuration.nix
```

4. Add the new host to `flake.nix`:

```nix
nixosConfigurations = {
  # ... existing hosts ...

  new-host = nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs userConfig; };
    modules = [
      ./hosts/new-host
      ./hosts/common
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs userConfig; };
          users.${userConfig.username} = import ./home/nixos.nix;
        };
      }
    ];
  };
};
```

### Testing with Virtual Machine

```bash
# Build a VM image
nix build .#nixosConfigurations.latitude.config.system.build.vm

# Run the VM
./result/bin/run-*-vm
```

### Pre-commit Hooks

```bash
# Install hooks (one-time setup)
pre-commit install

# Run all checks manually
pre-commit run --all-files
```

The hooks run:
- **nixpkgs-fmt**: Nix code formatter
- **statix**: Static analysis for Nix anti-patterns
- **deadnix**: Detects unused bindings and dead code

### Linting

```bash
# Check flake syntax and evaluations
nix flake check

# Static analysis for Nix anti-patterns
nix run nixpkgs#statix -- check .

# Detect unused bindings and dead code
nix run nixpkgs#deadnix -- --fail --no-lambda-pattern-names .
```
