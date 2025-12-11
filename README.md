# NixOS and Home Manager Configuration

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
# or: sudo nixos-rebuild switch --flake .#elitedesk
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
├── flake.nix                 # Main flake entry point
├── flake.lock                # Flake lock file
├── hosts/                    # NixOS host configurations
│   ├── common/               # Shared NixOS configuration
│   ├── latitude/             # Dell Latitude specific
│   └── elitedesk/            # HP EliteDesk specific
├── home/                     # Home Manager configurations
│   ├── common/               # Shared home configuration
│   ├── nixos.nix             # NixOS-specific home config
│   └── standalone.nix        # Standalone (ChromeOS/WSL) config
├── modules/                  # Reusable NixOS modules
│   ├── desktop/
│   │   ├── gnome.nix
│   │   └── i3.nix
│   └── docker.nix
├── home-modules/             # Reusable Home Manager modules
│   ├── shell/                # Shell tools, git, tmux, claude.nix
│   ├── dev/                  # Development languages and tools
│   ├── tools/                # DevOps and cloud tools
│   └── desktop/              # Desktop applications (NixOS only)
├── dotfiles/                 # Dotfiles deployed to home directory
│   └── claude/               # Claude Code configuration
│       ├── CLAUDE.md         # Global Claude instructions
│       ├── commands/         # Custom slash commands
│       ├── agents/           # Custom agent definitions
│       └── skills/           # Custom skills
└── scripts/                  # Utility scripts
    └── partition.sh          # Disk partitioning helper for installation
```

## Included Software

### Shell Tools
bat, fzf, gh, git, htop, pre-commit, rclone, ripgrep, rsync, screen, starship, terraform, terragrunt, tmux, vim

### Development
Python, Node.js, Go, gcc, make, cmake, claude-code, gemini-cli, opencode

### DevOps
AWS CLI, kubectl, helm, k9s, infisical

### Desktop (NixOS only)
Firefox, Chrome, VSCode, LibreOffice, GIMP, mtPaint

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
Both Gnome (default) and i3 window manager are available. Select at the login screen.

#### i3 Key Bindings
- `Mod+Enter` - Open terminal
- `Mod+d` - Application launcher (dmenu/rofi)
- `Mod+Shift+q` - Close window
- `Mod+1-9` - Switch workspace
- `Mod+Shift+1-9` - Move window to workspace

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
# or: sudo nixos-install --flake /tmp/nix#elitedesk

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
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs userConfig; };
        home-manager.users.${userConfig.username} = import ./home/nixos.nix;
      }
    ];
  };
};
```

### Testing with Virtual Machine

#### Using QEMU

```bash
# Build a VM image
nix build .#nixosConfigurations.latitude.config.system.build.vm

# Run the VM
./result/bin/run-*-vm
```

#### Using Proxmox

```bash
# Build a QCOW2 image
nix build .#nixosConfigurations.latitude.config.system.build.qcow

# Copy to Proxmox storage
scp result/nixos.qcow2 proxmox:/var/lib/vz/images/
```
