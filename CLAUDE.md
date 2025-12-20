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
.github/         # CI/CD workflows
  workflows/
    nix-check.yml  # Flake check, statix, and deadnix linting

hosts/           # NixOS system configurations
  common/        # Shared across all NixOS hosts
  dev/           # Proxmox VM (headless server)
  latitude/      # Dell Latitude 7420
  lounge/        # HP EliteDesk 800 G2 Mini

modules/         # All modules
  nixos/         # NixOS modules
    desktop/     # Gnome, i3
    docker.nix
  home/          # Home Manager modules
    shell/       # Core tools, dev languages, devops tools
      default.nix   # Git, tmux, bash, starship, neovim, core CLI tools
      dev.nix       # Python, Node, Go, AI CLI, Claude dotfiles
      devops.nix    # AWS, kubectl, helm, k9s, infisical
    desktop/     # Desktop applications (NixOS only)
      default.nix   # LibreOffice, GIMP, mtPaint, Cura, XScreenSaver (lounge only)
      browsers.nix  # Firefox, Chrome with extensions
      vscode.nix    # VSCode with extensions
      gnome.nix     # Gnome-specific settings
      media.nix     # Kodi, VLC, mpv, ffmpeg

home/            # Home Manager entry points
  common/        # Shared home config (imports shell modules)
  nixos.nix      # NixOS desktop entry (adds desktop modules)
  server.nix     # NixOS server entry (shell only, no desktop)
  standalone.nix # Standalone entry (shell only, for WSL/ChromeOS)

dotfiles/        # Dotfiles deployed to home directory
  claude/        # Claude Code configuration (synced via modules/home/shell/dev.nix)

scripts/         # Utility scripts
  partition.sh   # Disk partitioning helper
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
- **User**: louis (in wheel, docker, podman groups)
- **Shell**: bash with starship prompt
- **Tmux prefix**: Ctrl+a (not Ctrl+b)
- **Git**: pull.rebase = false
- **Docker**: Default container runtime (Podman also available)
- **Claude Code**: Dotfiles in `dotfiles/claude/` are automatically symlinked to `~/.claude/` via `modules/home/shell/dev.nix`
- **Host-specific configs**: `hostName` parameter passed via `extraSpecialArgs` enables conditional features (e.g., XScreenSaver on lounge only)

### Nix Code Style

- **Use inherit syntax**: Prefer `inherit system;` over `system = system;`
- **Group repeated attributes**: Use nested sets for repeated attribute prefixes
  ```nix
  # Good
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Avoid
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  ```
- **Lambda pattern names**: Unused lambda parameters in module signatures are acceptable (e.g., `{ config, pkgs, lib, ... }`)

## Package Locations

| Category | Location | Notes |
|----------|----------|-------|
| System packages | `hosts/common/default.nix` | Minimal (vim, git, wget, curl, VPN tools) |
| Core CLI tools | `modules/home/shell/default.nix` | bat, eza, fzf, ripgrep, restic, rclone, database clients, tofu/terragrunt |
| Dev languages | `modules/home/shell/dev.nix` | Python, Node.js, Go, build tools (gcc, cmake, make) |
| AI CLI tools | `modules/home/shell/dev.nix` | claude-code, codex, gemini-cli, opencode |
| DevOps tools | `modules/home/shell/devops.nix` | AWS CLI, kubectl, helm, k9s, infisical |
| Desktop apps | `modules/home/desktop/default.nix` | LibreOffice, GIMP, mtPaint, Cura (NixOS only) |
| Browsers | `modules/home/desktop/browsers.nix` | Firefox, Chrome with extensions (NixOS only) |
| VSCode | `modules/home/desktop/vscode.nix` | VSCode with extensions (NixOS only) |
| Media applications | `modules/home/desktop/media.nix` | Kodi (with NFS media sources), VLC, mpv, ffmpeg (NixOS only) |
| Screensaver | `modules/home/desktop/default.nix` | XScreenSaver (lounge host only; latitude uses GNOME power management) |

## Firefox Extensions

Managed via NUR (Nix User Repository) in `modules/home/desktop/browsers.nix`:
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
# Install pre-commit hooks (one-time setup)
pre-commit install

# Run all pre-commit checks manually
pre-commit run --all-files

# Check flake syntax and evaluations
nix flake check

# Run linting (same checks as CI)
nix run nixpkgs#statix -- check .
nix run nixpkgs#deadnix -- --fail --no-lambda-pattern-names .

# Build without switching
nix build .#nixosConfigurations.latitude.config.system.build.toplevel

# Test in VM
nix build .#nixosConfigurations.latitude.config.system.build.vm
./result/bin/run-*-vm
```

## Continuous Integration

GitHub Actions runs on all pushes and pull requests to the main branch:

| Job | Purpose | Commands |
|-----|---------|----------|
| `check` | Verify flake syntax and evaluations | `nix flake check` |
| `lint` | Check Nix code quality | `statix check .`<br>`deadnix --fail --no-lambda-pattern-names .` |

**Linting Tools:**
- **statix**: Catches common Nix anti-patterns and suggests idiomatic alternatives
  - W04: Suggests using `inherit` syntax
  - W20: Recommends grouping repeated attribute keys into nested sets
- **deadnix**: Detects unused bindings and dead code
  - Configured with `--no-lambda-pattern-names` to ignore unused module function parameters (standard in NixOS)

## Common Issues

### Firefox Extensions Not Loading
The NUR input may need to be added to flake.nix if Firefox extensions fail:
```nix
inputs.nur.url = "github:nix-community/NUR";
```

### VSCode Extension SHA Mismatch
Update the sha256 in `modules/home/desktop/vscode.nix` when extension versions change.

### Hardware Config Missing
Generate on target machine: `nixos-generate-config --show-hardware-config`
