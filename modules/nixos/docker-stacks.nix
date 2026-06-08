# Docker host directory setup: persistent paths for volumes and stacks
{ config, lib, pkgs, ... }:

let
  cfg = config.custom.docker-stacks;
in
{
  options.custom.docker-stacks = {
    enable = lib.mkEnableOption "Docker stacks git pull timer";

    repo = lib.mkOption {
      type = lib.types.str;
      default = "git@github.com:jinglemansweep/docker-stacks.git";
    };

    path = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/docker/stacks";
    };

    schedule = lib.mkOption {
      type = lib.types.str;
      default = "*:0/15";
    };

    branch = lib.mkOption {
      type = lib.types.str;
      default = "main";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d /mnt/docker/volumes 0777 root root -"
      "d /mnt/docker/stacks 0755 root root -"
    ];

    sops.secrets.docker-stacks-deploy-key = {
      sopsFile = ../../secrets/secrets.yaml;
      key = "docker_stacks_deploy_key";
      path = "/root/.ssh/docker-stacks-deploy-key";
      owner = "root";
      group = "root";
      mode = "0600";
    };

    systemd.services.docker-stacks-pull = {
      description = "Pull docker stacks from git";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      requires = [ "sops-nix.service" ];
      serviceConfig = {
        Type = "oneshot";
        Environment = "GIT_SSH_COMMAND=ssh -i /root/.ssh/docker-stacks-deploy-key -o StrictHostKeyChecking=accept-new";
      };
      path = [ pkgs.git pkgs.openssh ];
      script = ''
        if [ -d "${cfg.path}/.git" ]; then
          git -C "${cfg.path}" pull
        else
          git clone -b "${cfg.branch}" "${cfg.repo}" "${cfg.path}"
        fi
      '';
    };

    systemd.timers.docker-stacks-pull = {
      description = "Periodic docker stacks git pull";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.schedule;
        Persistent = true;
        RandomizedDelaySec = "5min";
      };
    };
  };
}
