# NixOS-level SOPS secrets: user password hash
{ config, lib, pkgs, userConfig, ... }:

{
  sops = {
    defaultSopsFile = ../../secrets/shared.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets.user_password_hash = {
      neededForUsers = true;
    };
  };

  system.activationScripts.sops-age-key = ''
    if [ -f /etc/ssh/ssh_host_ed25519_key ]; then
      mkdir -p /var/lib/sops-nix
      ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key \
        > /var/lib/sops-nix/host-age-key
      chmod 644 /var/lib/sops-nix/host-age-key
    fi
  '';
}
