# Nix/NixOS Configuration Plan

## Overview

This document outlines the implementation plan for a Nix Flakes-based configuration supporting both full NixOS installations and standalone Home Manager environments.

## Locale & Region

| Setting  | Value            |
|----------|------------------|
| Language | `en_GB.UTF-8`    |
| Location | United Kingdom   |
| Timezone | `Europe/London`  |

## Architecture

```
.
├── flake.nix                 # Main flake entry point
├── flake.lock                # Flake lock file
├── hosts/                    # NixOS host configurations
│   ├── common/               # Shared NixOS configuration
│   │   └── default.nix
│   ├── dell-latitude-7420/   # Dell Latitude 7420 specific
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   └── hp-elitedesk-800g2/   # HP EliteDesk 800 G2 Mini specific
│       ├── default.nix
│       └── hardware-configuration.nix
├── home/                     # Home Manager configurations
│   ├── common/               # Shared home configuration
│   │   └── default.nix
│   ├── nixos.nix             # NixOS-specific home config
│   └── standalone.nix        # Standalone (ChromeOS/WSL) home config
├── modules/                  # Reusable NixOS modules
│   ├── desktop/
│   │   ├── gnome.nix
│   │   └── i3.nix
│   └── docker.nix
└── home-modules/             # Reusable Home Manager modules
    ├── shell/
    │   ├── default.nix       # Shell packages and config
    │   ├── git.nix
    │   └── tmux.nix
    ├── dev/
    │   ├── default.nix
    │   ├── python.nix
    │   ├── node.nix
    │   └── go.nix
    ├── tools/
    │   ├── default.nix
    │   ├── aws.nix
    │   ├── kubernetes.nix
    │   └── infisical.nix
    └── desktop/
        ├── default.nix
        ├── browsers.nix
        ├── vscode.nix
        └── apps.nix
```

## User Configuration

| Field     | Value                        |
|-----------|------------------------------|
| Username  | `louis`                      |
| Full Name | `Louis King`                 |
| Email     | `jinglemansweep@gmail.com`   |

## Target Systems

### 1. Dell Latitude 7420

- **Type**: Laptop
- **CPU**: Intel i7-1185G7
- **Display**: 14"
- **NixOS Output**: `nixosConfigurations.dell-latitude-7420`

### 2. HP EliteDesk 800 G2 Mini

- **Type**: Desktop Mini PC
- **NixOS Output**: `nixosConfigurations.hp-elitedesk-800g2`

### 3. Standalone Home Manager (ChromeOS/WSL)

- **Type**: Terminal/Dev environment only
- **Home Manager Output**: `homeConfigurations.louis`

## Implementation Tasks

### Phase 1: Flake Foundation

- [ ] Create `flake.nix` with inputs:
  - `nixpkgs` (unstable or latest stable)
  - `home-manager`
  - `nixos-hardware` (for hardware-specific optimizations)
- [ ] Define outputs for NixOS configurations and Home Manager configurations

### Phase 2: Common NixOS Configuration

- [ ] Base system settings (locale, timezone, networking)
- [ ] User account creation for `louis`
- [ ] Enable Nix Flakes and experimental features
- [ ] Docker module with Compose and Buildx support (default)
- [ ] Podman (alternative container runtime)
- [ ] OpenSSH server/client
- [ ] VPN/Networking:
  - OpenVPN client
  - Tailscale
  - WireGuard
- [ ] Sound (PipeWire)
- [ ] Fonts

### Phase 3: Host-Specific NixOS Configurations

#### Dell Latitude 7420
- [ ] Hardware configuration (generated via `nixos-generate-config`)
- [ ] Power management (TLP for laptop)
- [ ] Intel graphics drivers
- [ ] Laptop-specific tweaks (lid close, battery optimization)

#### HP EliteDesk 800 G2 Mini
- [ ] Hardware configuration
- [ ] Desktop-optimized power settings

### Phase 4: Desktop Environment Modules

#### Gnome (Default)
- [ ] Enable Gnome Desktop Manager (GDM)
- [ ] Gnome shell and core apps
- [ ] Gnome extensions (if needed)

#### i3 Window Manager (Alternative)
- [ ] i3 package and configuration
- [ ] i3status or polybar
- [ ] dmenu/rofi launcher
- [ ] Session entry in display manager

### Phase 5: Home Manager - Shell Environment

#### Core Shell Packages
- [ ] `bat` - cat alternative with syntax highlighting
- [ ] `fzf` - fuzzy finder
- [ ] `gh` - GitHub CLI
- [ ] `git` - version control
- [ ] `htop` - process viewer
- [ ] `pre-commit` - git hooks
- [ ] `rclone` - cloud storage sync
- [ ] `ripgrep` - fast grep
- [ ] `rsync` - file sync
- [ ] `screen` - terminal multiplexer
- [ ] `starship` - shell prompts
- [ ] `terraform` - infrastructure as code
- [ ] `terragrunt` - terraform wrapper
- [ ] `tmux` - terminal multiplexer
- [ ] `vim` - text editor

#### Compression Tools
- [ ] `zip` / `unzip`
- [ ] `gnutar`
- [ ] `xz`
- [ ] `gzip` / `gunzip`
- [ ] `p7zip`

#### Git Configuration
- [ ] Set `user.name` = "Louis King"
- [ ] Set `user.email` = "jinglemansweep@gmail.com"
- [ ] Disable rebase: `pull.rebase = false`

#### Tmux Configuration
- [ ] Set prefix to `Ctrl+a` (unbind `Ctrl+b`)

### Phase 6: Home Manager - Development Tools

#### Python
- [ ] Latest Python 3.x
- [ ] pip
- [ ] Common dev packages (virtualenv, etc.)

#### Node.js
- [ ] Latest Node.js LTS or current
- [ ] npm (included)
- [ ] npx (included)

#### Go
- [ ] Latest Go version

#### Build Tools
- [ ] `gnumake`
- [ ] `gcc` / `clang`
- [ ] `pkg-config`
- [ ] Common build dependencies

#### AI Coding Assistants (CLI)
- [ ] `claude-code` - Anthropic Claude Code CLI
- [ ] `gemini-cli` - Google Gemini CLI
- [ ] `opencode` - OpenCode CLI

### Phase 7: Home Manager - DevOps Tools

#### AWS
- [ ] `awscli2` - AWS CLI v2

#### Kubernetes
- [ ] `kubectl` - Kubernetes CLI
- [ ] `helm` - Kubernetes package manager

#### Infisical
- [ ] `infisical` - secrets manager CLI

### Phase 8: Home Manager - Desktop Applications (NixOS only)

#### Browsers
- [ ] Firefox (set as default)
  - Extensions:
    - uBlock Origin
    - Bitwarden
- [ ] Google Chrome

#### Development
- [ ] VSCode with extensions:
  - `anthropic.claude-code` - Claude Code
  - `ms-vscode-remote.remote-containers` - Dev Containers
  - `ms-azuretools.vscode-docker` - Docker
  - `hashicorp.terraform` - Terraform
  - `ms-vscode-remote.remote-ssh` - Remote SSH
  - `ms-vscode-remote.remote-ssh-edit` - Remote SSH Edit
  - `ms-vscode.remote-server` - Remote Server
  - `redhat.vscode-yaml` - YAML

#### Office
- [ ] LibreOffice suite

#### Graphics
- [ ] mtPaint - simple image editor
- [ ] GIMP - advanced image editor

#### Terminal
- [ ] gnome-terminal
- [ ] rxvt-unicode (urxvt)

## Flake Outputs Summary

```nix
{
  nixosConfigurations = {
    dell-latitude-7420 = { /* Full NixOS + Home Manager */ };
    hp-elitedesk-800g2 = { /* Full NixOS + Home Manager */ };
  };

  homeConfigurations = {
    louis = { /* Standalone Home Manager for ChromeOS/WSL */ };
  };
}
```

## Usage Commands

### NixOS Rebuild (on NixOS systems)

```bash
# Dell Latitude
sudo nixos-rebuild switch --flake .#dell-latitude-7420

# HP EliteDesk
sudo nixos-rebuild switch --flake .#hp-elitedesk-800g2
```

### Standalone Home Manager (ChromeOS/WSL)

```bash
# Initial setup
nix run home-manager -- switch --flake .#louis

# Subsequent updates
home-manager switch --flake .#louis
```

## Documentation (README.md)

The README.md must include comprehensive documentation covering:

### Installation Guides
- [ ] Prerequisites and requirements
- [ ] Installing Nix with Flakes support (for standalone environments)
- [ ] Standalone Home Manager setup (ChromeOS/WSL)
- [ ] Full NixOS installation from bootable USB
  - Creating bootable USB media
  - Partitioning and formatting
  - Running the installer
  - Post-installation configuration

### Usage Guides
- [ ] Updating an existing NixOS installation
- [ ] Updating standalone Home Manager configuration
- [ ] Adding new hosts/machines
- [ ] Customizing configurations

### Testing
- [ ] Testing with a virtual machine (QEMU/VirtualBox)
- [ ] Building and testing configurations before applying

## Notes

- All configurations use Nix Flakes exclusively (no legacy `nix-channel`)
- Home Manager is integrated as a NixOS module for full NixOS installs
- Home Manager runs standalone for ChromeOS/WSL environments
- Desktop-specific modules only loaded on NixOS configurations
- Hardware configurations will need to be generated on actual hardware using `nixos-generate-config`
