{ config, pkgs, lib, ... }:

{
  imports = [
    ./browsers.nix
    ./vscode.nix
    ./apps.nix
  ];
}
