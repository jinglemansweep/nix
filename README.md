# NixOS and Home Manager Configuration

A Nix Flakes-based configuration supporting full NixOS installations and standalone Home Manager environments.

## Target Systems

| System | Type | Configuration |
|--------|------|---------------|
| Dell Latitude 7420 | Laptop (i7-1185G7) | `nixosConfigurations.latitude` |
| HP EliteDesk 800 G2 Mini | Desktop | `nixosConfigurations.elitedesk` |
| ChromeOS/WSL | Terminal only | `homeConfigurations.louis` |

## Prerequisites

### For Standalone Home Manager (ChromeOS/WSL)

Install Nix with Flakes support:

```bash
# Install Nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# Enable Flakes (add to ~/.config/nix/nix.conf or /etc/nix/nix.conf)
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### For NixOS Installation

Download the NixOS ISO from [nixos.org](https://nixos.org/download.html).

## Installation

### Standalone Home Manager (ChromeOS/WSL)

```bash
# Clone this repository
git clone https://github.com/yourusername/nix-config.git
cd nix-config

# Initial Home Manager setup
nix run home-manager -- switch --flake .#louis

# Subsequent updates
home-manager switch --flake .#louis
```

### Full NixOS Installation from USB

#### 1. Create Bootable USB

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

# Generate hardware configuration
sudo nixos-generate-config --root /mnt

# Clone this repository
sudo git clone https://github.com/yourusername/nix-config.git /mnt/etc/nixos

# Copy generated hardware-configuration.nix to the appropriate host directory
# For Dell Latitude:
sudo cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/latitude/

# For HP EliteDesk:
# sudo cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/elitedesk/

# Install NixOS
sudo nixos-install --flake /mnt/etc/nixos#latitude
# or
# sudo nixos-install --flake /mnt/etc/nixos#elitedesk

# Set root password when prompted
# Reboot
sudo reboot
```

### Dual-Boot with Windows 11 (Dell Latitude 7420)

This guide covers replacing an existing Ubuntu installation with NixOS while preserving Windows 11.

#### Prerequisites

- Windows 11 already installed
- Existing Linux partition (Ubuntu) to replace
- USB drive with NixOS ISO

#### 1. Disable Secure Boot (Temporarily)

NixOS doesn't support Secure Boot out of the box. You'll need to disable it:

1. Reboot and enter BIOS/UEFI settings (press F2 during Dell splash screen)
2. Navigate to **Secure Boot** → **Secure Boot Enable**
3. Set to **Disabled**
4. Save and exit (F10)

> **Note**: You can re-enable Secure Boot later using `lanzaboote` (see "Enabling Secure Boot with NixOS" section below).

#### 2. Boot from NixOS USB

1. Insert NixOS USB drive
2. Reboot and press F12 for boot menu
3. Select the USB drive (UEFI mode)

#### 3. Identify Existing Partitions

```bash
# List all partitions
lsblk -f

# You should see something like:
# nvme0n1p1  vfat   EFI        # Windows/shared EFI partition - DO NOT FORMAT
# nvme0n1p2  ntfs   Windows    # Windows system - DO NOT TOUCH
# nvme0n1p3  ntfs   WinRecovery # Windows recovery - DO NOT TOUCH
# nvme0n1p4  ext4   Ubuntu     # Ubuntu root - REPLACE THIS
# nvme0n1p5  swap   swap       # Existing swap - CAN REUSE
```

#### 4. Format Linux Partitions (Keep EFI!)

```bash
# IMPORTANT: Do NOT format the EFI partition (nvme0n1p1)
# Only format the partition where Ubuntu was installed

# Format the root partition (replace nvme0n1p4 with your Ubuntu partition)
sudo mkfs.ext4 -L nixos /dev/nvme0n1p4

# If you have a swap partition, you can reformat it
sudo mkswap -L swap /dev/nvme0n1p5
```

#### 5. Mount Partitions

```bash
# Mount NixOS root
sudo mount /dev/disk/by-label/nixos /mnt

# Mount the EXISTING Windows EFI partition (do not format!)
sudo mkdir -p /mnt/boot
sudo mount /dev/nvme0n1p1 /mnt/boot

# Enable swap
sudo swapon /dev/disk/by-label/swap
```

#### 6. Generate and Install

```bash
# Generate hardware configuration
sudo nixos-generate-config --root /mnt

# Clone this repository
sudo git clone https://github.com/yourusername/nix-config.git /mnt/etc/nixos

# Copy generated hardware-configuration.nix
sudo cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/latitude/

# Install NixOS
sudo nixos-install --flake /mnt/etc/nixos#latitude

# Reboot
sudo reboot
```

#### 7. Post-Installation: Boot Menu

After installation, systemd-boot will be the bootloader. It should automatically detect Windows:

- At boot, you'll see a menu with NixOS and Windows Boot Manager
- Use arrow keys to select, Enter to boot
- Press `d` to set default, `t` to set timeout

If Windows doesn't appear, add it manually by editing `/boot/loader/loader.conf`:

```bash
sudo systemd-boot update
```

Or add a manual entry in `hosts/common/default.nix`:

```nix
boot.loader.systemd-boot.extraEntries = {
  "windows.conf" = ''
    title Windows 11
    efi /EFI/Microsoft/Boot/bootmgfw.efi
  '';
};
```

#### Enabling Secure Boot with NixOS (Optional)

To re-enable Secure Boot, you can use `lanzaboote`:

1. Add to `flake.nix` inputs:

```nix
lanzaboote = {
  url = "github:nix-community/lanzaboote";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

2. Add to your host configuration:

```nix
{ inputs, ... }: {
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
}
```

3. Generate keys and enroll them:

```bash
sudo sbctl create-keys
sudo sbctl enroll-keys --microsoft
```

4. Rebuild and reboot, then re-enable Secure Boot in BIOS.

#### Troubleshooting Dual-Boot

**Windows time is wrong after booting NixOS:**

Add to `hosts/common/default.nix`:

```nix
time.hardwareClockInLocalTime = true;
```

**Windows Boot Manager missing:**

```bash
# Verify Windows EFI files exist
ls /boot/EFI/Microsoft/Boot/bootmgfw.efi

# If missing, boot into Windows recovery and run:
# bcdboot C:\Windows /s S: /f UEFI
```

**GRUB installed instead of systemd-boot:**

Our configuration uses systemd-boot. If you accidentally installed GRUB, remove it:

```bash
sudo rm -rf /boot/EFI/GRUB
sudo rm -rf /boot/grub
sudo bootctl install
```

#### 4. Post-Installation

After rebooting:

```bash
# Set user password
sudo passwd louis

# Clone config to home directory for easier management
git clone https://github.com/yourusername/nix-config.git ~/nix-config
cd ~/nix-config

# Future updates
sudo nixos-rebuild switch --flake .#latitude
```

## Updating

### NixOS

```bash
cd ~/nix-config

# Update flake inputs
nix flake update

# Rebuild system
sudo nixos-rebuild switch --flake .#latitude
# or
sudo nixos-rebuild switch --flake .#elitedesk
```

### Standalone Home Manager

```bash
cd ~/nix-config

# Update flake inputs
nix flake update

# Rebuild home configuration
home-manager switch --flake .#louis
```

## Testing with Virtual Machine

### Using QEMU

```bash
# Build a VM image
nix build .#nixosConfigurations.latitude.config.system.build.vm

# Run the VM
./result/bin/run-*-vm
```

### Using VirtualBox

1. Build an OVA image:

```bash
nix build .#nixosConfigurations.latitude.config.system.build.virtualBoxOVA
```

2. Import `result/*.ova` into VirtualBox

## Adding a New Host

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
└── home-modules/             # Reusable Home Manager modules
    ├── shell/
    ├── dev/
    ├── tools/
    └── desktop/
```

## Desktop Environments

Both Gnome (default) and i3 window manager are available. Select at the login screen.

### i3 Key Bindings

- `Mod+Enter` - Open terminal
- `Mod+d` - Application launcher (dmenu/rofi)
- `Mod+Shift+q` - Close window
- `Mod+1-9` - Switch workspace
- `Mod+Shift+1-9` - Move window to workspace

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
