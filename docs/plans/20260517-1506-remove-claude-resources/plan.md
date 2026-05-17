# Remove Old Claude Code Resources

## Summary

Remove the legacy `.claude/` directory and all associated Claude Code
references from the repository. This project has migrated to OpenCode
as its primary AI coding assistant, so the old Claude-specific agent
definitions, settings, and documentation references are no longer
needed.

## Background & Motivation

The `.claude/` directory currently contains two tracked files:
`agents/docs-writer.md` and `agents/nix-code-reviewer.md`, plus an
untracked `settings.local.json`. These are Claude Code agent
definitions that were created when Claude Code was the primary AI
assistant for this project. The project has since adopted OpenCode
(config deployed via `modules/home/gitsources.nix` from the
`agent-resources` flake input), and a parallel OpenCode skill exists at
`~/.config/opencode/skills/docs-writer/SKILL.md` (user-local, not in
this repo).

Additionally, `AGENTS.md` references Claude Code configuration and
deployment patterns that are outdated. Specifically, the "Claude Code"
convention entry (line 163) claims config is deployed from
`agent-resources` via `gitsources.nix`, but `gitsources.nix` only
deploys OpenCode config. The OpenCode convention entry (line 164) is
already correct. The `modules/home/shell/development.nix` file still
installs `pkgs.claude-code` and `modules/home/desktop/vscode.nix` has
Claude Code VSCode extension settings, but these are independent of the
`.claude/` directory and are out of scope.

Recent git history shows steady updates without any Claude-specific
changes, indicating these resources are dormant.

## Goals

- Remove the `.claude/` directory (tracked agent files and local
  settings) from the repository
- Clean up Claude Code references in `AGENTS.md` where they describe
  project conventions (as opposed to just listing an installed package)
- Ensure documentation accurately reflects the current AI tooling setup
  (OpenCode as primary, Claude Code as optional CLI tool if retained)

## Non-Goals

- Removing `pkgs.claude-code` from `development.nix` (it is a useful
  CLI tool regardless of the `.claude/` config directory)
- Removing Claude Code VSCode settings from `vscode.nix` (these
  configure the VSCode extension, not the `.claude/` directory)
- Changing the `agent-resources` flake input or OpenCode configuration
- Removing references to Claude Code from `README.md` package lists
  (factual listing of installed packages)

## Requirements

### Functional Requirements

- Delete `.claude/agents/docs-writer.md` from git tracking
- Delete `.claude/agents/nix-code-reviewer.md` from git tracking
- Remove `.claude/settings.local.json` (untracked, local only)
- Remove the `.claude/` directory entirely
- Remove the "Claude Code" convention entry in `AGENTS.md` Important
  Conventions section (it is factually incorrect — it claims
  `gitsources.nix` deploys Claude Code config when it only deploys
  OpenCode config; the adjacent OpenCode convention entry is correct)
- Keep the VSCode Claude Code paragraph in `AGENTS.md` (line 227) — it
  refers to VSCode extension settings in `vscode.nix`, not the
  `.claude/` directory, and VSCode settings are out of scope

### Technical Requirements

- No Nix configuration changes required (`.claude/` is not referenced
  by any Nix module)
- Changes should not break `nix flake check`
- No impact on the `agent-resources` flake input or OpenCode deployment

## Implementation Plan

### Phase 1: Remove .claude directory

- `git rm .claude/agents/docs-writer.md`
- `git rm .claude/agents/nix-code-reviewer.md`
- Delete `.claude/settings.local.json` locally
- Remove the `.claude/` directory

### Phase 2: Update documentation

- Edit `AGENTS.md`:
  - Remove the "Claude Code" convention entry (line 163) — it is
    factually incorrect (`gitsources.nix` deploys OpenCode config, not
    Claude Code config). The adjacent OpenCode entry (line 164) already
    correctly describes the agent-resources deployment.
  - Keep the VSCode Claude Code paragraph (line 227) — it describes
    VSCode extension settings in `vscode.nix`, which are out of scope.
- Verify `README.md` Claude Code references are only factual package
  listings (no convention or configuration claims)

### Phase 3: Verify

- Run `nix flake check` to confirm no breakage
- Run `pre-commit run --all-files` to verify linting passes
- Confirm no remaining references to `.claude/` in the codebase

## References

- `.claude/agents/docs-writer.md` (to be removed)
- `.claude/agents/nix-code-reviewer.md` (to be removed)
- `AGENTS.md:163` (factually incorrect Claude Code convention to remove)
- `AGENTS.md:164` (correct OpenCode convention to keep as-is)
- `AGENTS.md:227` (VSCode Claude Code reference to keep as-is)
- `modules/home/gitsources.nix` (OpenCode config deployment)
- `modules/home/shell/development.nix:66` (claude-code package)
- `modules/home/desktop/vscode.nix:43-44` (Claude Code VSCode config)

## Review

**Status**: Approved

**Reviewed**: 2026-05-17

### Resolutions

- **AGENTS.md:163 is factually wrong**: The line claims
  `agent-resources` deploys "Claude Code" config via `gitsources.nix`,
  but `gitsources.nix` only deploys OpenCode config. The adjacent
  OpenCode entry (line 164) already correctly describes this
  deployment. Resolution: remove line 163 entirely.
- **AGENTS.md:227 should be kept**: This paragraph describes VSCode
  extension settings (`claudeCode.preferredLocation` in `vscode.nix`),
  not the `.claude/` directory. VSCode settings are a declared
  Non-Goal and are independent. Resolution: keep as-is.
- **Incorrect docs-writer path**: The Background section used a
  relative path `.config/opencode/skills/docs-writer/SKILL.md` for
  the OpenCode skill. The actual path is
  `~/.config/opencode/skills/docs-writer/SKILL.md` (user-local, not
  in the repo). Resolution: corrected path in Background.
- **Open Questions already resolved by Non-Goals**: Both open
  questions (VSCode settings removal, claude-code package) are already
  answered by the Non-Goals section. Resolution: removed Open
  Questions section.

### Remaining Action Items

- `nix flake check` must pass after changes
- `pre-commit run --all-files` must pass after changes
- Verify no stray `.claude/` references remain in the codebase
