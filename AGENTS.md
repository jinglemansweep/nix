# AI Agent Project Guidelines

This is a Nix Flakes-based configuration for NixOS and Home Manager.

## Project Overview

- **Purpose**: Manage NixOS systems and Home Manager environments
- **User**: Louis King (louis / jinglemansweep@gmail.com)
- **Approach**: Nix Flakes only (no legacy nix-channel)

## Key Files

| File | Purpose |
|------|---------|
| `flake.nix` | Main entry point, defines all outputs |
| `lib/default.nix` | Utility library (exports `files` and `hosts` modules) |
| `lib/files.nix` | `mkFileMappings` helper for dotfile deployment |
| `lib/hosts.nix` | Host builder functions (`mkDesktopHost`, `mkDevHost`, `mkCloudHost`) |
| `.sops.yaml` | SOPS configuration |
| `.github/workflows/nix-check.yml` | CI workflow for linting and flake checks |
| `.pre-commit-config.yaml` | Pre-commit hooks for local linting |
| `hosts/common/default.nix` | Shared NixOS configuration (networking, VPN, filesystem tools) |
| `hosts/common/desktop.nix` | Desktop additions (GUI, audio, printing, fonts, mounts) |
| `hosts/<hostname>/default.nix` | Host-specific NixOS config |
| `hosts/<hostname>/hardware-configuration.nix` | Hardware-specific config (generated) |
| `home/common/default.nix` | Shared Home Manager config |
| `home/nixos.nix` | NixOS Home Manager entry (includes desktop) |
| `home/server.nix` | NixOS server Home Manager entry (shell + development tools) |
| `home/cloud.nix` | Cloud server Home Manager entry (base + docker tools) |
| `home/standalone.nix` | ChromeOS/WSL Home Manager entry (shell + development tools) |

## Directory Structure

```
.github/workflows/
  nix-check.yml        # Flake check, statix, and deadnix linting

lib/                    # Utility library
  default.nix          # Exports files and hosts modules
  files.nix            # mkFileMappings: recursive dir-to-home.file mapping
  hosts.nix            # Host builder functions (mkDesktopHost, mkDevHost, mkCloudHost)

hosts/                 # NixOS system configurations
  common/              # Shared across all NixOS hosts
    default.nix        # Base system configuration (networking, VPN, filesystem tools)
    desktop.nix        # Desktop additions (GUI, audio, printing, fonts, mounts)
  dev/                 # Proxmox VM (headless server, nix-ld for VS Code Remote SSH)
  ipnet-s1/            # Cloud server (Docker runner)
  latitude/            # Dell Latitude 7420
  lounge/              # HP EliteDesk 800 G2 Mini
  pt-s1/               # Cloud server (Docker runner)

modules/
  nixos/               # NixOS modules
    desktop/
      common.nix       # Shared desktop config (input devices, system packages, desktop.enable option)
      gnome.nix        # GNOME desktop module
      sway.nix         # Sway window manager module
    secrets.nix        # NixOS-level SOPS secrets (user password hash)
    systemd/
      default.nix      # Systemd service imports
      nix-gc.nix       # Automated garbage collection
    mounts.nix         # NFS automounts for Synology NAS
    virtualisation.nix # Docker and Podman configuration
  home/                # Home Manager modules
    shell/
      base.nix         # Git, tmux, bash, starship, neovim, GPG, SSH, core CLI
      dev.nix          # Languages, LSPs, AI CLI, DevOps, database clients, dev secrets
      docker.nix       # Container management tools (lazydocker)
    desktop/
      default.nix      # Alacritty terminal, udiskie automount, imports other desktop modules
      browsers.nix     # Firefox and Chromium with extensions and bookmarks
      development.nix  # Zed editor with extensions and AI agent config
      emulators.nix    # Retro gaming emulators (ZX Spectrum)
      gnome.nix        # GNOME extensions, keyring, dconf settings
      media.nix        # Kodi with PVR IPTV addon and NFS media sources
      sway.nix         # Sway window manager configuration
      vscode.nix       # VSCode editor with extensions and settings
    env.nix            # Environment variable configuration (SOPS-managed)
    gitsources.nix     # External git-sourced dotfiles (agent-resources flake input)
    secrets.nix        # SOPS secrets with age encryption

home/                  # Home Manager entry points
  common/              # Shared home config (SOPS, XDG directories)
  cloud.nix            # Cloud server entry (base + docker tools only)
  nixos.nix            # NixOS desktop entry (adds desktop modules)
  server.nix           # NixOS server entry (shell + development tools)
  standalone.nix       # Standalone entry (ChromeOS/WSL, shell + development tools)

secrets/
  secrets.yaml         # Age-encrypted secrets (SOPS)

docs/
  plans/               # Implementation plans and task lists

scripts/
  partition.sh         # Disk partitioning helper
```

## Flake Structure

### Inputs

| Input | Source | Purpose |
|-------|--------|---------|
| `nixpkgs` | nixos-unstable | Package set |
| `home-manager` | nix-community | Home Manager |
| `nixos-hardware` | NixOS | Hardware-specific configs |
| `nur` | nix-community | Nix User Repo (Firefox extensions) |
| `sops-nix` | Mic92 | Secrets management |
| `agent-resources` | jinglemansweep | External dotfiles (OpenCode config) |

### specialArgs

All hosts receive `{ inherit inputs userConfig projectLib; }` as specialArgs.

- **userConfig**: `{ username, fullName, email, githubUsername, nfsHost, gpgSigningKey }`
- **projectLib**: Import of `lib/` — provides `files.mkFileMappings` for dotfile deployment

### Cloud Host Helper

`mkCloudHost dir` creates a NixOS config that adds virtualisation + systemd modules, using the `home/cloud.nix` entry point. Cloud hosts define their own firewall and QEMU guest settings inline.

## Configuration Targets

| Target | Command |
|--------|---------|
| Dell Latitude 7420 | `sudo nixos-rebuild switch --flake .#latitude` |
| HP EliteDesk 800 G2 Mini (Lounge) | `sudo nixos-rebuild switch --flake .#lounge` |
| Proxmox VM (Dev Server) | `sudo nixos-rebuild switch --flake .#dev` |
| Cloud Server (PT-S1) | `sudo nixos-rebuild switch --flake .#pt-s1` |
| Cloud Server (IPNet-S1) | `sudo nixos-rebuild switch --flake .#ipnet-s1` |
| Standalone (WSL/ChromeOS) | `home-manager switch --flake .#louis` |

## Adding New Features

### New NixOS Module
1. Create file in `modules/nixos/`
2. Import in `hosts/common/default.nix` or specific host
3. For desktop modules: gate behind `config.desktop.enable` option

### New Home Manager Module
1. Create file in `modules/home/<category>/`
2. Import in the category's `default.nix`
3. For desktop-only: import in `modules/home/desktop/default.nix`
4. For all environments: import in `home/common/default.nix`

### New Host
1. Create `hosts/<hostname>/default.nix`
2. Generate `hardware-configuration.nix` on target hardware
3. Add to `flake.nix` nixosConfigurations

### New External Dotfiles (from flake input)
1. Add repo as a flake input in `flake.nix` (set `flake = false` if it has no `flake.nix`)
2. Add `xdg.configFile` or `home.file` entries in `modules/home/gitsources.nix`
3. Run `nix flake update` to fetch and pin the repo

## Important Conventions

- **Locale**: en_GB.UTF-8, Europe/London timezone
- **User**: louis (in networkmanager, wheel, docker groups; desktop hosts also add podman, dialout, scanner, lp, disk)
- **Shell**: bash with starship prompt
- **Tmux prefix**: Ctrl+a (not Ctrl+b)
- **Git**: pull.rebase = false
- **Docker**: Default container runtime (Podman also available)
- **OpenCode**: Config deployed from `agent-resources` flake input via `modules/home/gitsources.nix` (updates via `nix flake update`)
- **Direnv**: nix-direnv with custom `load_secrets` helpers
- **Secrets**: SOPS with age encryption (`secrets/secrets.yaml`)
- **Work modules**: Self-contained modules that include their own secrets and env templates (e.g., `modules/home/shell/dev.nix`)
- **Desktop toggle**: `desktop.enable` option in `modules/nixos/desktop/common.nix` — gate for desktop-only features

### Secrets Management

**SOPS (age encryption)** - configured in `modules/nixos/secrets.nix`, `modules/home/secrets.nix`, and `modules/home/shell/dev.nix`:
- Secrets files:
  - `secrets/nixos.yaml` — NixOS-level secrets (`user_password_hash`), all hosts
  - `secrets/common.yaml` — shared Home Manager secrets, all hosts
  - `secrets/dev.yaml` — dev API keys (`context7_api_key`, `zai_api_key`), desktop+dev hosts only
- Age key: `~/.config/sops/age/keys.txt`
- NixOS-level secrets: `user_password_hash`
- Home Manager secrets: `context7_api_key`, `zai_api_key`

**Environment variables** - configured in `modules/home/env.nix` and `modules/home/shell/dev.nix`:
- `CONTEXT7_API_KEY`, `ZAI_API_KEY`

**Direnv helpers** - for environment variables:
```bash
# In .envrc
use flake
load_secrets my-project    # Loads ~/.secrets/global.env + ~/.secrets/projects/my-project.env
```

### Nix Code Style

- **File headers**: Each file has a concise comment describing its purpose
- **Use inherit syntax**: Prefer `inherit system;` over `system = system;`
- **Group repeated attributes**: Use nested sets for repeated attribute prefixes
- **Minimal inline comments**: Only where behavior isn't self-evident

## Package Locations

| Category | Location | Examples |
|----------|----------|----------|
| System packages | `hosts/common/default.nix` | vim, git, wget, curl, dnsutils, bubblewrap, openvpn, wireguard-tools, cifs-utils, nfs-utils |
| Desktop apps (system) | `modules/nixos/desktop/common.nix` | Firefox, Chrome, Discord, LibreOffice, GIMP, Pinta, VLC, mpv, ffmpeg, Shotcut, Cura, Thonny, Tiled, Evince, Baobab, rxvt-unicode, rpi-imager |
| Core CLI tools | `modules/home/shell/base.nix` | bat, eza, fd, ripgrep, tree, ncdu, dust, duf, glow, yazi, fzf, tldr, htop, btop, vim, screen, jq, yq, jless, delta, fastfetch, keychain, infisical, borgbackup, rclone, restic, imagemagick, inkscape, lsof, rsync, zip, unzip, gnutar, xz, bzip2, gzip, p7zip, usbutils, psmisc; programs: zoxide, direnv, neovim, gpg, ssh, gpg-agent |
| Dev languages | `modules/home/shell/dev.nix` | Python 3 (pip, virtualenv, pipx, pyyaml, poetry, uv, ruff), Node.js, Rust (rustc, cargo), Go, build tools (gcc, gnumake, cmake, pkg-config, autoconf, automake, libtool) |
| Language servers | `modules/home/shell/dev.nix` | gopls, nil, nixd, pyright, typescript-language-server, yaml-language-server, terraform-ls, dockerfile-language-server, bash-language-server, vscode-langservers-extracted |
| Lint tools | `modules/home/shell/dev.nix` | eslint, shellcheck, yamllint, markdownlint-cli |
| AI CLI tools | `modules/home/shell/dev.nix` | claude-code, codex, gemini-cli, opencode |
| DevOps tools | `modules/home/shell/dev.nix` | opentofu, terragrunt, awscli2, kubectl, kubernetes-helm, k9s, pre-commit, gh, github-copilot-cli, lazygit |
| Database clients | `modules/home/shell/dev.nix` | postgresql, mariadb, redis, sqlite |
| MicroPython tools | `modules/home/shell/dev.nix` | picocom, esptool, picotool, mpremote, mosquitto, esphome |
| Docker tools | `modules/home/shell/docker.nix` | lazydocker |
| Browsers (user) | `modules/home/desktop/browsers.nix` | Firefox extensions (uBlock, Bitwarden), Chromium, bookmarks |
| Development editors | `modules/home/desktop/development.nix` | Zed editor with extensions and AI agent config, OpenCode desktop client |
| Emulators | `modules/home/desktop/emulators.nix` | fuse-emulator, zesarux (ZX Spectrum) |
| Media | `modules/home/desktop/media.nix` | Kodi with PVR IPTV addon and NFS media sources |

## VSCode Extensions

Managed in `modules/home/desktop/vscode.nix`:
- Remote (Containers, SSH, SSH Edit, WSL)
- Ansible
- Docker
- GitHub Actions
- Nix
- Python (with Black formatter)
- Terraform
- YAML

Claude Code is configured via user settings (not an extension), pointing to the Home Manager-wrapped `claude` binary.

## Zed Editor

Configured in `modules/home/desktop/development.nix` with extensions: basher, csv, dockerfile, docker-compose, github-actions, zhtml, nix, ruff, terraform, toml. Includes OpenCode agent server integration, Z.AI language model provider, and SSH connections to dev server. Also installs `opencode-desktop` package.

## Testing Changes

```bash
# Pre-commit hooks (one-time setup)
pre-commit install

# Run all checks manually
pre-commit run --all-files

# Check flake
nix flake check

# Linting
nix run nixpkgs#statix -- check .
nix run nixpkgs#deadnix -- --fail --no-lambda-pattern-names .

# Build without switching
nix build .#nixosConfigurations.latitude.config.system.build.toplevel

# Test in VM
nix build .#nixosConfigurations.latitude.config.system.build.vm
./result/bin/run-*-vm
```

## Continuous Integration

GitHub Actions runs on pushes and PRs to main:

| Job | Purpose |
|-----|---------|
| `check` | `nix flake check` |
| `lint` | `statix check .` and `deadnix --fail --no-lambda-pattern-names .` |

## Common Issues

### Firefox Extensions Not Loading
Ensure NUR is in flake inputs:
```nix
inputs.nur.url = "github:nix-community/NUR";
```

### VSCode Extension SHA Mismatch
Update sha256 in `modules/home/shell/dev.nix` when versions change.

### Hardware Config Missing
Generate on target: `nixos-generate-config --show-hardware-config`

### Broken Packages
- `mongosh`: Commented out in dev.nix (npm cache issue)
- `mtpaint`: Removed (incompatible with libpng 1.6.52)
