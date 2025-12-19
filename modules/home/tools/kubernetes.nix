{ config, pkgs, lib, ... }:

{
  home.packages = [
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.k9s # Terminal UI for Kubernetes
  ];

  # kubectl completion
  programs.bash.initExtra = ''
    source <(kubectl completion bash)
    alias k=kubectl
    complete -o default -F __start_kubectl k
  '';
}
