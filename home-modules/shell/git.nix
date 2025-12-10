{ config, pkgs, lib, userConfig, ... }:

{
  programs.git = {
    enable = true;
    userName = userConfig.fullName;
    userEmail = userConfig.email;

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core = {
        editor = "vim";
        autocrlf = "input";
      };
      push.autoSetupRemote = true;
      color.ui = "auto";
    };

    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      lg = "log --oneline --graph --decorate";
    };
  };
}
