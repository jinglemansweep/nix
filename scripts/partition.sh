#!/usr/bin/env bash
set -euo pipefail

# Partition script for Dell Latitude 7420
# Run this from a NixOS minimal USB boot

DISK="/dev/nvme0n1"

echo "=== NixOS Partition Script for Dell Latitude 7420 ==="
echo ""
echo "WARNING: This will ERASE ALL DATA on ${DISK}"
echo ""
lsblk "${DISK}"
echo ""
read -p "Are you sure you want to continue? (yes/no): " confirm

if [[ "${confirm}" != "yes" ]]; then
    echo "Aborted."
    exit 1
fi

echo ""
echo "==> Creating GPT partition table..."
parted "${DISK}" -- mklabel gpt

echo "==> Creating EFI partition (512MB)..."
parted "${DISK}" -- mkpart ESP fat32 1MB 512MB
parted "${DISK}" -- set 1 esp on

echo "==> Creating root partition..."
parted "${DISK}" -- mkpart primary 512MB -8GB

echo "==> Creating swap partition (8GB)..."
parted "${DISK}" -- mkpart primary linux-swap -8GB 100%

echo ""
echo "==> Formatting partitions..."
mkfs.fat -F 32 -n boot "${DISK}p1"
mkfs.ext4 -L nixos "${DISK}p2"
mkswap -L swap "${DISK}p3"

echo ""
echo "==> Mounting partitions..."
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap

echo ""
echo "=== Partitioning complete ==="
echo ""
lsblk "${DISK}"
echo ""
echo "Next steps:"
echo "  1. git clone https://github.com/jinglemansweep/nix.git /tmp/nix"
echo "  2. nixos-install --flake /tmp/nix#latitude"
