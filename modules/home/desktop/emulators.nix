# Emulators: retro gaming and computing emulators
{ pkgs, ... }:

{
  home.packages = [
    pkgs.fuse-emulator # ZX Spectrum emulator
    pkgs.zesarux # ZX Spectrum emulator
  ];
}
