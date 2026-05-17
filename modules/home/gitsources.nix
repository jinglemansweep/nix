# External git-sourced dotfiles: deploys opencode config from agent-resources flake input
{ inputs, ... }:

{
  xdg.configFile."opencode" = {
    source = "${inputs.agent-resources}/opencode";
    recursive = true;
  };
}
