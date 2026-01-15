# Systemd unit: Docker volume backup with restic
{ config, lib, pkgs, ... }:

let
  cfg = config.custom.systemd.docker-backup;
  hostname = config.networking.hostName;
in
{
  options.custom.systemd.docker-backup = {
    enable = lib.mkEnableOption "Docker volume backup timer";

    schedule = lib.mkOption {
      type = lib.types.str;
      default = "daily";
      description = "Systemd calendar expression for backup schedule";
    };

    localPath = lib.mkOption {
      type = lib.types.str;
      default = "/var/backup/docker-volumes";
      description = "Local directory for volume tarballs";
    };

    resticRepository = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/nfs/lab/docker/backup/${hostname}/volumes";
      description = "Restic repository path";
    };

    retentionDays = lib.mkOption {
      type = lib.types.int;
      default = 30;
      description = "Days to keep backups";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.docker-backup = {
      description = "Backup Docker volumes to restic";
      requires = [ "docker.service" ];
      wants = [ "network-online.target" ];
      after = [ "docker.service" "network-online.target" ];
      path = [ pkgs.docker pkgs.restic pkgs.gzip pkgs.coreutils ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "docker-backup" ''
          set -euo pipefail

          LOCAL_PATH="${cfg.localPath}"
          RESTIC_REPO="${cfg.resticRepository}"
          RETENTION_DAYS="${toString cfg.retentionDays}"

          RESTIC_OPTS="--insecure-no-password"

          # Get all volumes
          mapfile -t volumes < <(docker volume ls -q)

          if [[ ''${#volumes[@]} -eq 0 ]]; then
            echo "No volumes to backup"
            exit 0
          fi

          # Find containers using volumes
          declare -A containers_to_stop
          for vol in "''${volumes[@]}"; do
            while IFS= read -r c; do
              [[ -n "$c" ]] && containers_to_stop[$c]=1
            done < <(docker ps -q --filter "volume=$vol")
          done

          # Stop containers
          stopped=()
          for c in "''${!containers_to_stop[@]}"; do
            echo "Stopping container $c"
            docker stop "$c"
            stopped+=("$c")
          done

          # Backup each volume
          mkdir -p "$LOCAL_PATH"
          for vol in "''${volumes[@]}"; do
            echo "Backing up volume $vol"
            docker run --rm \
              -v "$vol":/data:ro \
              -v "$LOCAL_PATH":/backup \
              alpine tar -czf "/backup/''${vol}.tar.gz" -C /data .
          done

          # Restart containers
          for c in "''${stopped[@]}"; do
            echo "Starting container $c"
            docker start "$c"
          done

          # Initialize restic repo if needed
          if ! restic $RESTIC_OPTS -r "$RESTIC_REPO" snapshots >/dev/null 2>&1; then
            echo "Initializing restic repository"
            restic $RESTIC_OPTS -r "$RESTIC_REPO" init --repository-version 2
          fi

          # Backup and prune
          echo "Running restic backup"
          restic $RESTIC_OPTS -r "$RESTIC_REPO" backup "$LOCAL_PATH"
          restic $RESTIC_OPTS -r "$RESTIC_REPO" forget --keep-within "''${RETENTION_DAYS}d" --prune
          echo "Backup complete"
        '';
      };
    };

    systemd.timers.docker-backup = {
      description = "Periodic Docker volume backup";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.schedule;
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
    };
  };
}
