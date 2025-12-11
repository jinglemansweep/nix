{ config, pkgs, lib, ... }:

{
  # Symlink specific claude directories (not the whole .claude folder)
  home.file = {
    ".claude/commands" = {
      source = ../../dotfiles/claude/commands;
      recursive = true;
    };
    ".claude/agents" = {
      source = ../../dotfiles/claude/agents;
      recursive = true;
    };
    ".claude/skills" = {
      source = ../../dotfiles/claude/skills;
      recursive = true;
    };
    # Global CLAUDE.md goes in the root
    ".claude/CLAUDE.md".source = ../../dotfiles/claude/CLAUDE.md;
  };
}
