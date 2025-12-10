# Nix / NixOS Configuration

You are a Nix and NixOS expert.

Create a Nix and NixOS configuration with the following requirements:

* Full NixOS Installation (Laptop and Desktops)
* Terminal/Shell "Dev" Environment (ChromeOS/WSL)

Also create a comprehensive README.md detailing how to install and configure both the standalone shell dev environment and a NixOS installation, including installing from a bootable USB, updating an existing installation, and testing with a virtual machine.

## Rules

* ONLY use new Flakes, no legacy Nix concepts
* MUST use Home Manager

## NixOS

Current targets:

* Dell Latitude 7420 14" i7-1185G7
* HP EliteDesk 800 G2 Mini

* Must support separate configuration for each target
* Desktop should include Gnome (default) and `i3` tiling window manager setup

* Language: en_GB.UTF-8
* Location: United Kingdom
* Timezone: Europe/London

## User Details

Username: `louis`
Full Name: `Louis King`
Email: `jinglemansweep@gmail.com`

## Components

* Docker, Compose, Buildx etc
* Dev:
  * Languages: Python (current), Node (current) [npm, npx], Go (current)
  * Tools: Make, build tools
* Shell: 
  * Packages: 
    * bat, fzf, gh (github), git, htop, pre-commit
    * rclone, ripgrep, rsync, screen, starship (prompt)
    * terraform, terragrunt, tmux, vim
  * Compression and decompression tools (zip/unzip/tar/xz)
* Tools:
  * aws (cli)
  * infisical (secrets manager)
  * kubectl, helm
* Desktop:
  * Gnome desktop (default)
  * i3 WM (alternative)
  * Office suite
  * Graphics editors (MTPaint, Gimp)
  * Terminal emulator (gnome-terminal, uvxt-unicode)
  * Firefox (default)
  * Google Chrome (not default)
  * VSCode

### git

* Disable rebase
* Set user details (above)

### tmux

* MUST use Ctrl+a as prefix key


