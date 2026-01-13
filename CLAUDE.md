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
  dev/                 # Proxmox VM (headless server, nix-ld for VS Code Remote SSH)
  latitude/            # Dell Latitude 7420
  lounge/              # HP EliteDesk 800 G2 Mini

modules/
  nixos/               # NixOS modules
    desktop/
      common.nix       # Shared desktop config (input devices, system packages)
      gnome.nix        # GNOME desktop module
      i3.nix           # i3 window manager module
    docker.nix         # Docker with Compose and Buildx
    mounts.nix         # NFS automounts for Synology NAS
  home/                # Home Manager modules
    shell/
      default.nix      # Git, tmux, bash, starship, neovim, GPG, SSH, core CLI
      dev.nix          # Python, Node.js, Go, language servers, AI CLI tools
      devops.nix       # AWS CLI, kubectl, helm, k9s, infisical
    desktop/
      default.nix      # Alacritty terminal, udiskie automount
      browsers.nix     # Firefox with extensions and bookmarks
      gnome.nix        # GNOME extensions, keyring, dconf settings
      i3.nix           # i3 config, i3status-rust, picom, rofi
      media.nix        # Kodi with NFS media sources
      vscode.nix       # VSCode with extensions
      zed.nix          # Zed editor (disabled, config preserved)
    secrets.nix        # SOPS secrets with age encryption

home/                  # Home Manager entry points
  common/              # Shared home config (imports shell modules)
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
| Core CLI tools | `modules/home/shell/default.nix` | bat, eza, fzf, ripgrep, htop, btop, lazygit, lazydocker, borgbackup, rclone, restic, opentofu, terragrunt |
| Dev languages | `modules/home/shell/dev.nix` | Python, Node.js, Go, language servers (pyright, nil, typescript-language-server), build tools |
| AI CLI tools | `modules/home/shell/dev.nix` | claude-code, codex, gemini-cli, opencode |
| MicroPython tools | `modules/home/shell/dev.nix` | picocom, esptool, picotool, mpremote |
| DevOps tools | `modules/home/shell/devops.nix` | AWS CLI, kubectl, helm, k9s, infisical |
| Desktop apps (system) | `modules/nixos/desktop/common.nix` | Firefox, Chrome, LibreOffice, GIMP, Pinta, VLC, mpv, ffmpeg, Cura, Thonny, Tiled |
| Browsers (user) | `modules/home/desktop/browsers.nix` | Firefox extensions (uBlock, Bitwarden), bookmarks |
| VSCode | `modules/home/desktop/vscode.nix` | VSCode with extensions |
| Media | `modules/home/desktop/media.nix` | Kodi with NFS media sources |

## Firefox Extensions

Managed via NUR in `modules/home/desktop/browsers.nix`:
- uBlock Origin
- Bitwarden

## VSCode Extensions

Managed in `modules/home/desktop/vscode.nix`:
- Remote (Containers, SSH, WSL)
- Ansible
- Claude Code (Anthropic)
- Docker
- GitHub Actions
- Nix
- Python (with Black formatter)
- Terraform
- YAML

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
- `mongosh`: Commented out in dev.nix (npm cache issue)
- `mtpaint`: Removed (incompatible with libpng 1.6.52)
