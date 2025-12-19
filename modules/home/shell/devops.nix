{ config, pkgs, lib, ... }:

{
  home.packages = [
    # AWS
    pkgs.awscli2

    # Kubernetes
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.k9s

    # Secrets management
    pkgs.infisical
  ];

  # kubectl completion and alias
  programs.bash.initExtra = ''
    source <(kubectl completion bash)
    alias k=kubectl
    complete -o default -F __start_kubectl k
  '';
}
