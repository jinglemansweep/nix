# Systemd unit: periodic Nix garbage collection
{ config, lib, pkgs, ... }:

let
  cfg = config.custom.systemd.nix-gc;
in
{
  options.custom.systemd.nix-gc = {
    enable = lib.mkEnableOption "Nix garbage collection timer";

    schedule = lib.mkOption {
      type = lib.types.str;
      default = "weekly";
      description = "Systemd calendar expression for GC schedule";
    };

    olderThan = lib.mkOption {
      type = lib.types.str;
      default = "30d";
      description = "Delete generations older than this (e.g., 7d, 30d)";
    };

    optimiseStore = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Run nix-store --optimise after GC";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.nix-gc-custom = {
      description = "Nix garbage collection";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "nix-gc" ''
          ${pkgs.nix}/bin/nix-collect-garbage --delete-older-than ${cfg.olderThan}
          ${lib.optionalString cfg.optimiseStore "${pkgs.nix}/bin/nix-store --optimise"}
        '';
      };
    };

    systemd.timers.nix-gc-custom = {
      description = "Periodic Nix garbage collection";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.schedule;
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
    };
  };
}
