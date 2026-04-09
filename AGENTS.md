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
| `lib/default.nix` | Utility library (exports `files` module) |
| `lib/files.nix` | `mkFileMappings` helper for dotfile deployment |
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
  default.nix          # Exports files module
  files.nix            # mkFileMappings: recursive dir-to-home.file mapping

hosts/                 # NixOS system configurations
  common/              # Shared across all NixOS hosts
    default.nix        # Base system configuration (networking, VPN, filesystem tools)
    desktop.nix        # Desktop additions (GUI, audio, printing, fonts, mounts)
  cloud/               # Cloud Root server (Docker Swarm/Compose runner)
  dev/                 # Proxmox VM (headless server, nix-ld for VS Code Remote SSH)
  latitude/            # Dell Latitude 7420
  lounge/              # HP EliteDesk 800 G2 Mini

modules/
  nixos/               # NixOS modules
    desktop/
      common.nix       # Shared desktop config (input devices, system packages, desktop.enable option)
      gnome.nix        # GNOME desktop module
      sway.nix         # Sway window manager module
    roles/
      cloud-server.nix # Cloud server role (firewall ports 80/443, QEMU guest agent)
    systemd/
      default.nix      # Systemd service imports
      nix-gc.nix       # Automated garbage collection
    mounts.nix         # NFS automounts for Synology NAS
    virtualisation.nix # Docker and Podman configuration
  home/                # Home Manager modules
    shell/
      base.nix         # Git, tmux, bash, starship, neovim, GPG, SSH, core CLI
      development.nix  # Languages, LSPs, AI CLI, DevOps, database clients, VSCode
      docker.nix       # Container management tools (lazydocker)
    desktop/
      default.nix      # Alacritty terminal, udiskie automount, imports other desktop modules
      browsers.nix     # Firefox and Chromium with extensions and bookmarks
      development.nix  # Zed editor with extensions and AI agent config
      emulators.nix    # Retro gaming emulators (ZX Spectrum)
      gnome.nix        # GNOME extensions, keyring, dconf settings
      media.nix        # Kodi with PVR IPTV addon and NFS media sources
      sway.nix         # Sway window manager configuration
    env.nix            # Environment variable configuration (SOPS-managed)
    secrets.nix        # SOPS secrets with age encryption

home/                  # Home Manager entry points
  common/              # Shared home config (SOPS, XDG directories)
  cloud.nix            # Cloud server entry (base + docker tools only)
  nixos.nix            # NixOS desktop entry (adds desktop modules)
  server.nix           # NixOS server entry (shell + development tools)
  standalone.nix       # Standalone entry (ChromeOS/WSL, shell + development tools)

dotfiles/
  claude/              # Claude Code configuration
    CLAUDE.md          # Global Claude instructions
    commands/          # Custom slash commands
    agents/            # Custom agent definitions
    skills/            # Custom skills
    settings.json      # Claude settings
    mcp_settings.json  # MCP server configuration
  opencode/            # OpenCode configuration
    opencode.json      # Server config and MCP servers
    commands/          # Custom commands
    agents/            # Custom agents
    skills/            # Custom skills (dev-react, expert-testing, expert-security, etc.)
  direnv/
    direnvrc           # Custom direnv functions (load_secrets helpers)

secrets/
  secrets.yaml         # Age-encrypted secrets (SOPS)

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

### specialArgs

All hosts receive `{ inherit inputs userConfig projectLib; }` as specialArgs.

- **userConfig**: `{ username, fullName, email, githubUsername, nfsHost }`
- **projectLib**: Import of `lib/` — provides `files.mkFileMappings` for dotfile deployment

### Cloud Host Helper

`mkCloudHost dir: fqdn` creates a NixOS config that automatically sets `hostName` and `domain` from the FQDN, and adds cloud-server role + virtualisation + systemd modules.

## Configuration Targets

| Target | Command |
|--------|---------|
| Dell Latitude 7420 | `sudo nixos-rebuild switch --flake .#latitude` |
| HP EliteDesk 800 G2 Mini (Lounge) | `sudo nixos-rebuild switch --flake .#lounge` |
| Proxmox VM (Dev Server) | `sudo nixos-rebuild switch --flake .#dev` |
| Cloud Root Server | `sudo nixos-rebuild switch --flake .#s1` |
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

### New Dotfiles
1. Add files under `dotfiles/<tool>/`
2. Use `projectLib.files.mkFileMappings` in the relevant Home Manager module to deploy

## Important Conventions

- **Locale**: en_GB.UTF-8, Europe/London timezone
- **User**: louis (in networkmanager, wheel, docker groups; desktop hosts also add podman, dialout, scanner, lp, disk)
- **Shell**: bash with starship prompt
- **Tmux prefix**: Ctrl+a (not Ctrl+b)
- **Git**: pull.rebase = false
- **Docker**: Default container runtime (Podman also available)
- **Claude Code**: Dotfiles in `dotfiles/claude/` deployed via `projectLib.files.mkFileMappings`
- **OpenCode**: Dotfiles in `dotfiles/opencode/` deployed via `projectLib.files.mkFileMappings`
- **Direnv**: nix-direnv with custom `load_secrets` helpers
- **Secrets**: SOPS with age encryption (`secrets/secrets.yaml`)
- **Desktop toggle**: `desktop.enable` option in `modules/nixos/desktop/common.nix` — gate for desktop-only features

### Secrets Management

**SOPS (age encryption)** - configured in `modules/home/secrets.nix`:
- Secrets file: `secrets/secrets.yaml`
- Age key: `~/.config/sops/age/keys.txt`
- Managed secrets: `home_lab_nfs_host`, `home_lab_nfs_root`, `home_lab_traefik_domain`, `infisical_project_id`, `infisical_env`, `context7_api_key`, `zai_api_key`

**Environment variables** - configured in `modules/home/env.nix`:
- `LAB_NFS_HOST`, `LAB_NFS_ROOT`, `LAB_TRAEFIK_DOMAIN`
- `INFISICAL_PROJECT_ID`, `INFISICAL_ENV`
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
| Desktop apps (system) | `modules/nixos/desktop/common.nix` | Firefox, Chrome, LibreOffice, GIMP, Pinta, VLC, mpv, ffmpeg, Shotcut, Cura, Thonny, Tiled, Evince, Baobab, rxvt-unicode, rpi-imager |
| Core CLI tools | `modules/home/shell/base.nix` | bat, eza, fd, ripgrep, tree, ncdu, dust, duf, glow, yazi, fzf, htop, btop, vim, screen, jq, yq, jless, delta, fastfetch, keychain, borgbackup, rclone, restic, imagemagick, inkscape |
| Dev languages | `modules/home/shell/development.nix` | Python 3 (pip, virtualenv, pipx, pyyaml, poetry, uv, ruff), Node.js, Rust (rustc, cargo), Go (gotools), build tools (gcc, gnumake, cmake, pkg-config, autoconf, automake, libtool) |
| Language servers | `modules/home/shell/development.nix` | gopls, nil, nixd, pyright, typescript-language-server, yaml-language-server, terraform-ls, dockerfile-language-server, bash-language-server, vscode-langservers-extracted |
| Lint tools | `modules/home/shell/development.nix` | eslint, shellcheck, yamllint, markdownlint-cli |
| AI CLI tools | `modules/home/shell/development.nix` | claude-code, codex, gemini-cli, opencode |
| DevOps tools | `modules/home/shell/development.nix` | opentofu, terragrunt, awscli2, kubectl, kubernetes-helm, k9s, infisical, pre-commit, gh, github-copilot-cli, lazygit |
| Database clients | `modules/home/shell/development.nix` | postgresql, mariadb, redis, sqlite |
| MicroPython tools | `modules/home/shell/development.nix` | picocom, esptool, picotool, mpremote, mosquitto, esphome |
| Docker tools | `modules/home/shell/docker.nix` | lazydocker |
| Browsers (user) | `modules/home/desktop/browsers.nix` | Firefox extensions (uBlock, Bitwarden), Chromium, bookmarks |
| Development editors | `modules/home/desktop/development.nix` | Zed editor with extensions and AI agent config |
| Emulators | `modules/home/desktop/emulators.nix` | fuse-emulator, zesarux (ZX Spectrum) |
| Media | `modules/home/desktop/media.nix` | Kodi with PVR IPTV addon and NFS media sources |

## VSCode Extensions

Managed in `modules/home/shell/development.nix`:
- Remote (Containers, SSH, SSH Edit, WSL)
- Ansible
- Claude Code (Anthropic, from marketplace)
- Docker
- GitHub Actions
- Nix
- Python (with Black formatter)
- Terraform
- YAML

## Zed Editor

Configured in `modules/home/desktop/development.nix` with extensions: basher, csv, dockerfile, docker-compose, github-actions, html, nix, ruff, terraform, toml. Includes OpenCode agent server integration and Z.AI language model provider.

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
Update sha256 in `modules/home/shell/development.nix` when versions change.

### Hardware Config Missing
Generate on target: `nixos-generate-config --show-hardware-config`

### Broken Packages
- `mongosh`: Commented out in development.nix (npm cache issue)
- `mtpaint`: Removed (incompatible with libpng 1.6.52)
