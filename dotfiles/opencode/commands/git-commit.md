---
description: Stage changes, run quality gates, and commit
---

You are creating a git commit. Follow these steps in order:

1. Run `git status` and `git diff --staged` to understand what has changed. If nothing is staged, also run `git diff` to see unstaged changes.

2. Identify the scope of changes — which files and what they do.

3. Run the appropriate quality gates before committing:

   - If a `.pre-commit-config.yaml` exists in the project, run `pre-commit run --all-files`. Fix any failures before proceeding.
   - If no pre-commit config exists, detect the language/framework and run the appropriate linters/tests:
     - Nix: `nix run nixpkgs#statix -- check .` and `nix run nixpkgs#deadnix -- --fail --no-lambda-pattern-names .`
     - Python: `ruff check .` or the project's configured linter
     - JavaScript/TypeScript: `npm run lint` or `npx eslint .`
     - Go: `go vet ./...` and `golangci-lint run`
   - If `nix flake check` is applicable (project has a `flake.nix`), run it as a final validation.
   - If any quality gate fails, fix the issues and re-run until all pass.

4. Stage the relevant files with `git add`. Only stage files that are part of the logical change — do not stage unrelated modifications, generated files, or secrets.

5. Create a commit with a descriptive message that:
   - Uses the imperative mood (e.g. "Add", "Fix", "Refactor", "Update")
   - Focuses on the "why" rather than the "what"
   - Is 1-2 sentences, concise but informative
   - Does NOT include a scope prefix in parentheses unless the project convention requires it
   - Follows the style of recent commits in `git log --oneline -5`

6. After committing, run `git status` to confirm the working tree is clean (or show what remains).

DO NOT push to any remote. The commit stays local.
