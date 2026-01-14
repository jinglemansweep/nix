# DevOps tools: AWS CLI, Kubernetes, and secrets management
{ config, pkgs, lib, ... }:

{
  home.packages = [
    pkgs.awscli2
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.k9s
    pkgs.infisical
  ];

  programs.bash.initExtra = ''
    source <(kubectl completion bash)
    alias k=kubectl
    complete -o default -F __start_kubectl k
    alias secrets-infisical='infisical --silent --projectId ''${INFISICAL_PROJECT_ID} --env ''${INFISICAL_ENV}'
  '';
}
