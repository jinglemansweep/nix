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
| `hosts/common/default.nix` | Shared NixOS configuration |
| `hosts/<hostname>/default.nix` | Host-specific NixOS config |
| `hosts/<hostname>/hardware-configuration.nix` | Hardware-specific config (generated) |
| `home/common/default.nix` | Shared Home Manager config |
| `home/nixos.nix` | NixOS Home Manager entry (includes desktop) |
| `home/standalone.nix` | ChromeOS/WSL Home Manager entry (no desktop) |

## Directory Structure

```
hosts/           # NixOS system configurations
  common/        # Shared across all NixOS hosts
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
      default.nix   # LibreOffice, GIMP, mtPaint
      browsers.nix  # Firefox, Chrome with extensions
      vscode.nix    # VSCode with extensions
      gnome.nix     # Gnome-specific settings

home/            # Home Manager entry points
  common/        # Shared home config (imports shell modules)
  nixos.nix      # NixOS entry (adds desktop modules)
  standalone.nix # Standalone entry (shell only)

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

## Package Locations

| Category | Location | Notes |
|----------|----------|-------|
| System packages | `hosts/common/default.nix` | Minimal (vim, git, wget, curl, VPN tools) |
| Core CLI tools | `modules/home/shell/default.nix` | bat, eza, fzf, ripgrep, restic, rclone, database clients, tofu/terragrunt |
| Dev languages | `modules/home/shell/dev.nix` | Python, Node.js, Go, build tools (gcc, cmake, make) |
| AI CLI tools | `modules/home/shell/dev.nix` | claude-code, codex, gemini-cli, opencode |
| DevOps tools | `modules/home/shell/devops.nix` | AWS CLI, kubectl, helm, k9s, infisical |
| Desktop apps | `modules/home/desktop/default.nix` | LibreOffice, GIMP, mtPaint (NixOS only) |
| Browsers | `modules/home/desktop/browsers.nix` | Firefox, Chrome with extensions (NixOS only) |
| VSCode | `modules/home/desktop/vscode.nix` | VSCode with extensions (NixOS only) |

## Firefox Extensions

Managed via NUR (Nix User Repository) in `modules/home/desktop/browsers.nix`:
- uBlock Origin
- Bitwarden

## VSCode Extensions

Managed in `modules/home/desktop/vscode.nix`:
- Remote containers/SSH
- Docker
- Terraform
- YAML

## Testing Changes

```bash
# Check flake syntax
nix flake check

# Build without switching
nix build .#nixosConfigurations.latitude.config.system.build.toplevel

# Test in VM
nix build .#nixosConfigurations.latitude.config.system.build.vm
./result/bin/run-*-vm
```

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
