# Claude Code Project Guidelines

This is a Nix Flakes-based configuration for NixOS and Home Manager.

## Project Overview

- **Purpose**: Manage NixOS systems and Home Manager environments
- **User**: Louis King (louis / jinglemansweep@gmail.com)
- **Approach**: Nix Flakes only (no legacy nix-channel)

## Key Files

| File | Purpose |
|------|---------|
| `flake.nix` | Main entry point, defines all outputs |
| `.github/workflows/nix-check.yml` | CI workflow for linting and flake checks |
| `.pre-commit-config.yaml` | Pre-commit hooks for local linting |
| `hosts/common/default.nix` | Shared NixOS configuration |
| `hosts/<hostname>/default.nix` | Host-specific NixOS config |
| `hosts/<hostname>/hardware-configuration.nix` | Hardware-specific config (generated) |
| `home/common/default.nix` | Shared Home Manager config |
| `home/nixos.nix` | NixOS Home Manager entry (includes desktop) |
| `home/server.nix` | NixOS server Home Manager entry (no desktop) |
| `home/standalone.nix` | ChromeOS/WSL Home Manager entry (no desktop) |

## Directory Structure

```
.github/workflows/
  nix-check.yml        # Flake check, statix, and deadnix linting

hosts/                 # NixOS system configurations
  common/              # Shared across all NixOS hosts
    default.nix        # Base system configuration
    desktop.nix        # Desktop-specific system config
  dev/                 # Proxmox VM (headless server, nix-ld for VS Code Remote SSH)
  docker-runner/       # Proxmox VM (minimal Docker Swarm runner)
  latitude/            # Dell Latitude 7420
  lounge/              # HP EliteDesk 800 G2 Mini

modules/
  nixos/               # NixOS modules
    desktop/
      common.nix       # Shared desktop config (input devices, system packages)
      gnome.nix        # GNOME desktop module
      sway.nix         # Sway window manager module
    systemd/
      default.nix      # Systemd service imports
      docker-backup.nix # Docker volume backup service
      nix-gc.nix       # Automated garbage collection
    mounts.nix         # NFS automounts for Synology NAS
    virtualisation.nix # Docker and Podman configuration
  home/                # Home Manager modules
    shell/
      base.nix         # Git, tmux, bash, starship, neovim, GPG, SSH, core CLI
      development.nix  # Python, Node.js, Go, LSPs, AI CLI, DevOps, database clients
      docker.nix       # Container management tools (lazydocker)
    desktop/
      default.nix      # Alacritty terminal, udiskie automount, imports other desktop modules
      browsers.nix     # Firefox with extensions and bookmarks
      development.nix  # VSCode and Zed editor with extensions
      gnome.nix        # GNOME extensions, keyring, dconf settings
      media.nix        # Kodi with NFS media sources
      sway.nix         # Sway window manager configuration
    env.nix            # Environment variable configuration
    secrets.nix        # SOPS secrets with age encryption

home/                  # Home Manager entry points
  common/              # Shared home config (SOPS, XDG directories)
  docker-runner.nix    # Docker runner entry (base + docker tools only)
  nixos.nix            # NixOS desktop entry (adds desktop modules)
  server.nix           # NixOS server entry (shell only)
  standalone.nix       # Standalone entry (ChromeOS/WSL)

dotfiles/
  claude/              # Claude Code configuration
    CLAUDE.md          # Global Claude instructions
    commands/          # Custom slash commands
    agents/            # Custom agent definitions
    skills/            # Custom skills
    settings.json      # Claude settings
    mcp_settings.json  # MCP server configuration
  direnv/
    direnvrc           # Custom direnv functions (load_secrets helpers)

secrets/
  secrets.yaml         # Age-encrypted secrets (SOPS)

scripts/
  partition.sh         # Disk partitioning helper
```

## Configuration Targets

| Target | Command |
|--------|---------|
| Dell Latitude 7420 | `sudo nixos-rebuild switch --flake .#latitude` |
| HP EliteDesk 800 G2 Mini (Lounge) | `sudo nixos-rebuild switch --flake .#lounge` |
| Proxmox VM (Dev Server) | `sudo nixos-rebuild switch --flake .#dev` |
| Proxmox VM (Docker Runner) | `sudo nixos-rebuild switch --flake .#docker-runner` |
| Standalone (WSL/ChromeOS) | `home-manager switch --flake .#louis` |

## Adding New Features

### New NixOS Module
1. Create file in `modules/nixos/`
2. Import in `hosts/common/default.nix` or specific host

### New Home Manager Module
1. Create file in `modules/home/<category>/`
2. Import in the category's `default.nix`
3. For desktop-only: import in `modules/home/desktop/default.nix`
4. For all environments: import in `home/common/default.nix`

### New Host
1. Create `hosts/<hostname>/default.nix`
2. Generate `hardware-configuration.nix` on target hardware
3. Add to `flake.nix` nixosConfigurations

## Important Conventions

- **Locale**: en_GB.UTF-8, Europe/London timezone
- **User**: louis (in wheel, docker, podman, dialout, scanner, lp groups)
- **Shell**: bash with starship prompt
- **Tmux prefix**: Ctrl+a (not Ctrl+b)
- **Git**: pull.rebase = false
- **Docker**: Default container runtime (Podman also available)
- **Claude Code**: Dotfiles in `dotfiles/claude/` symlinked to `~/.claude/`
- **Direnv**: nix-direnv with custom `load_secrets` helpers
- **Secrets**: SOPS with age encryption (`secrets/secrets.yaml`)

### Secrets Management

**SOPS (age encryption)** - configured in `modules/home/secrets.nix`:
- Secrets file: `secrets/secrets.yaml`
- Age key: `~/.config/sops/age/keys.txt`

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
| System packages | `hosts/common/default.nix` | vim, git, wget, curl, VPN tools |
| Core CLI tools | `modules/home/shell/base.nix` | bat, eza, fzf, ripgrep, htop, btop, vim, screen, borgbackup, rclone, restic, imagemagick |
| Dev languages | `modules/home/shell/development.nix` | Python, Node.js, Go, build tools (gcc, make, cmake) |
| Language servers | `modules/home/shell/development.nix` | gopls, nil, pyright, typescript-language-server, yaml-language-server, terraform-ls, bash-language-server |
| AI CLI tools | `modules/home/shell/development.nix` | claude-code, codex, gemini-cli, opencode |
| DevOps tools | `modules/home/shell/development.nix` | opentofu, terragrunt, awscli2, kubectl, helm, k9s, infisical, pre-commit, gh, lazygit |
| Database clients | `modules/home/shell/development.nix` | postgresql, mariadb, redis, sqlite |
| MicroPython tools | `modules/home/shell/development.nix` | picocom, esptool, picotool, mpremote, mosquitto |
| Docker tools | `modules/home/shell/docker.nix` | lazydocker |
| Desktop apps (system) | `modules/nixos/desktop/common.nix` | Firefox, Chrome, LibreOffice, GIMP, Pinta, VLC, mpv, ffmpeg, Cura, Thonny, Tiled |
| Browsers (user) | `modules/home/desktop/browsers.nix` | Firefox extensions (uBlock, Bitwarden), bookmarks |
| Development editors | `modules/home/desktop/development.nix` | VSCode with extensions, Zed editor |
| Media | `modules/home/desktop/media.nix` | Kodi with NFS media sources |

## Firefox Extensions

Managed via NUR in `modules/home/desktop/browsers.nix`:
- uBlock Origin
- Bitwarden

## VSCode Extensions

Managed in `modules/home/desktop/development.nix`:
- Remote (Containers, SSH, WSL)
- Ansible
- Claude Code (Anthropic)
- Docker
- GitHub Actions
- Nix
- Python (with Black formatter)
- Terraform
- YAML

## Zed Editor

Configured in `modules/home/desktop/development.nix` with extensions for nix, toml, dockerfile, make, and html.

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
Update sha256 in `modules/home/desktop/vscode.nix` when versions change.

### Hardware Config Missing
Generate on target: `nixos-generate-config --show-hardware-config`

### Broken Packages
- `mongosh`: Commented out in development.nix (npm cache issue)
- `mtpaint`: Removed (incompatible with libpng 1.6.52)
