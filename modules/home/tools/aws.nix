{ config, pkgs, lib, ... }:

{
  home.packages = [
    pkgs.awscli2
    # pkgs.aws-sam-cli # Currently broken in nixpkgs (dependency version mismatch)
  ];
}
