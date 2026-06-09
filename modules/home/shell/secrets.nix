# Development API key secrets from SOPS
{ config, pkgs, lib, ... }:
{
  sops.secrets = {
    "context7_api_key" = {
      sopsFile = ../../secrets/dev.yaml;
    };
    "zai_api_key" = {
      sopsFile = ../../secrets/dev.yaml;
    };
  };
}
