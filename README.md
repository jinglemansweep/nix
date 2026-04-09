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
# or: sudo nixos-rebuild switch --flake .#s1
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
├── .sops.yaml                # SOPS configuration
├── flake.nix                 # Main flake entry point
├── flake.lock
├── lib/                      # Utility library
│   ├── default.nix           # Exports files module
│   └── files.nix             # mkFileMappings helper for dotfile deployment
├── hosts/                    # NixOS host configurations
│   ├── common/               # Shared NixOS configuration
│   │   ├── default.nix       # Base system configuration (networking, VPN, filesystem tools)
│   │   └── desktop.nix       # Desktop additions (GUI, audio, printing, fonts, mounts)
│   ├── cloud/                # Cloud Root server (Docker Swarm/Compose runner)
│   ├── dev/                  # Proxmox VM (headless, nix-ld for VS Code Remote SSH)
│   ├── latitude/             # Dell Latitude 7420
│   └── lounge/               # HP EliteDesk 800 G2 Mini
├── modules/
│   ├── nixos/                # NixOS system modules
│   │   ├── desktop/
│   │   │   ├── common.nix    # Shared desktop config, system packages, desktop.enable option
│   │   │   ├── gnome.nix     # GNOME desktop module
│   │   │   └── sway.nix      # Sway window manager module
│   │   ├── roles/
│   │   │   └── cloud-server.nix # Cloud server role (firewall, QEMU guest agent)
│   │   ├── systemd/
│   │   │   ├── default.nix   # Systemd service imports
│   │   │   └── nix-gc.nix    # Automated garbage collection
│   │   ├── mounts.nix        # NFS automounts for Synology NAS
│   │   └── virtualisation.nix # Docker and Podman configuration
│   └── home/                 # Home Manager modules
│       ├── shell/
│       │   ├── base.nix      # Git, tmux, bash, starship, neovim, GPG, SSH, core CLI
│       │   ├── development.nix # Languages, LSPs, AI CLI, DevOps, database clients, VSCode
│       │   └── docker.nix    # Container management tools (lazydocker)
│       ├── desktop/
│       │   ├── default.nix   # Alacritty terminal, udiskie, imports
│       │   ├── browsers.nix  # Firefox and Chromium with extensions and bookmarks
│       │   ├── development.nix # Zed editor with extensions and AI agent config
│       │   ├── emulators.nix # Retro gaming emulators (ZX Spectrum)
│       │   ├── gnome.nix     # GNOME extensions and dconf settings
│       │   ├── media.nix     # Kodi with PVR IPTV addon and NFS media sources
│       │   └── sway.nix      # Sway window manager configuration
│       ├── env.nix           # Environment variable configuration
│       └── secrets.nix       # SOPS secrets with age encryption
├── home/                     # Home Manager entry points
│   ├── common/               # Shared home configuration (SOPS, XDG)
│   ├── cloud.nix             # Cloud server (base + docker tools only)
│   ├── nixos.nix             # NixOS desktop (includes desktop modules)
│   ├── server.nix            # NixOS server (shell + development tools)
│   └── standalone.nix        # Standalone (ChromeOS/WSL, shell + development tools)
├── dotfiles/
│   ├── claude/               # Claude Code configuration
│   │   ├── CLAUDE.md
│   │   ├── commands/
│   │   ├── agents/
│   │   ├── skills/
│   │   ├── settings.json
│   │   └── mcp_settings.json
│   ├── opencode/             # OpenCode configuration
│   │   ├── opencode.json
│   │   ├── commands/
│   │   ├── agents/
│   │   └── skills/
│   └── direnv/
│       └── direnvrc          # Custom load_secrets helpers
├── secrets/
│   └── secrets.yaml          # Age-encrypted secrets (SOPS)
└── scripts/
    └── partition.sh          # Disk partitioning helper
```

## Included Software

### All Hosts

**System**: vim, git, wget, curl, dnsutils, openvpn, wireguard-tools, cifs-utils, nfs-utils

**Shell**: bash, starship, tmux (prefix `Ctrl+a`), neovim, fzf, zoxide, direnv, delta (git pager)

**CLI tools**: bat, eza, fd, ripgrep, tree, ncdu, dust, duf, glow, yazi, htop, btop, jq, yq, fastfetch

**Archive & system**: bzip2, gnutar, gzip, p7zip, unzip, xz, zip, psmisc, usbutils

**Backup**: borgbackup, rclone, restic

### Server / Standalone / Desktop

**Languages**: Python 3 (uv, poetry, ruff), Node.js, Rust, Go

**Build tools**: gcc, cmake, pkg-config, autoconf, automake

**LSPs**: gopls, nil/nixd, pyright, typescript-language-server, yaml-language-server, terraform-ls, bash-language-server

**AI CLI**: claude-code, codex, gemini-cli, opencode

**DevOps**: opentofu, terragrunt, awscli2, kubectl, helm, k9s, infisical, gh, lazygit

**Databases**: PostgreSQL, MariaDB, Redis, SQLite

**Editors**: VSCode (with Remote, Docker, Python, Terraform, Nix extensions)

### Desktop Only (NixOS)

**Desktop**: GNOME, Sway, Alacritty, Firefox (uBlock Origin, Bitwarden), Chromium

**Apps**: LibreOffice, GIMP, VLC, mpv, Shotcut, Evince, Cura, Thonny, Tiled

**Editors**: Zed (with AI agent integration)

**Media**: Kodi (PVR IPTV, NFS sources)

**Emulators**: ZX Spectrum (fuse-emulator, zesarux)

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
{ config, pkgs, lib, inputs, userConfig, projectLib, ... }:

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
    specialArgs = { inherit inputs userConfig projectLib; };
    modules = [
      ./hosts/new-host
      ./hosts/common
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs userConfig projectLib; };
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
