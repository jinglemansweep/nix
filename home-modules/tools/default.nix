{ config, pkgs, lib, ... }:

{
  imports = [
    ./aws.nix
    ./kubernetes.nix
    ./infisical.nix
  ];
}
