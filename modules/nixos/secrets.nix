# NixOS-level SOPS secrets: user password hash
{ config, lib, userConfig, ... }:

{
  sops = {
    defaultSopsFile = ../../secrets/shared.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets.user_password_hash = {
      neededForUsers = true;
    };
  };
}
