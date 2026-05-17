# Tasks: Remove Old Claude Code Resources

> Generated from `plan.md` on 2026-05-17

## Remove .claude directory

- [x] Delete tracked `.claude/` agent files from git
  - [x] `git rm .claude/agents/docs-writer.md`
  - [x] `git rm .claude/agents/nix-code-reviewer.md`
- [x] Remove untracked `.claude/settings.local.json` from disk
  - [x] `rm .claude/settings.local.json`
- [x] Remove empty `.claude/` directory tree
  - [x] `rmdir .claude/agents` (if empty after tracked file removal)
  - [x] `rmdir .claude/` (if empty after agents/ removal)

## Update AGENTS.md

- [x] Remove the factually incorrect "Claude Code" convention entry
  - [x] Delete line 163 (`- **Claude Code**: Config deployed from...`)
  - [x] Verify adjacent OpenCode entry (line 164) remains intact
- [x] Verify VSCode Claude Code paragraph (line 227) is preserved as-is
  - [x] Confirm it describes VSCode extension settings, not `.claude/`
    directory

## Verification

- [x] Run `nix flake check` to confirm no breakage
- [x] Run `pre-commit run --all-files` to verify linting passes
- [x] Verify no remaining `.claude/` references in tracked codebase
  - [x] `git grep '\.claude/'` should return no matches
