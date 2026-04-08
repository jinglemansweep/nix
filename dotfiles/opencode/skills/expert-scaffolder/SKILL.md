---
name: expert-scaffolder
description: "Use when creating a brand-new project from scratch with no existing code, dependencies, or patterns. Sets up the evergreen project skeleton that every new repository needs: pre-commit hooks, AGENTS.md agent instructions, README.md, and .gitignore. Delegates language-specific setup to the appropriate language skill after the skeleton is in place. Invoke for new project, scaffold, bootstrap, init project, create repo, project setup."
license: MIT
compatibility: opencode
metadata:
  author: https://github.com/jinglemansweep
  version: "0.1.0"
  domain: tooling
  triggers: new project, scaffold, bootstrap, init project, create repo, project setup, fresh project, greenfield, starter
  role: specialist
  scope: scaffolding
  output-format: code
  related-skills: dev-python, dev-javascript, expert-devops, expert-testing
---

# Scaffolder Expert

Project scaffolding specialist for bootstrapping new repositories with a consistent, evergreen skeleton.

## When to Use This Skill

- Creating a brand-new project from scratch (no existing code, deps, or patterns)
- Bootstrapping a new repository with best-practice defaults
- Setting up a greenfield project in any language
- Initializing project infrastructure before language-specific development

## When NOT to Use This Skill

- Existing projects with established patterns (follow what's already there)
- Adding features to an established codebase
- One-off scripts that don't need a full project structure

## Core Workflow

1. **Initialize** — `git init` (if not already a repo), create initial commit
2. **Detect language** — Ask user or infer from context which stack: Python, Node.js/TypeScript, Go, or Generic
3. **Create skeleton** — Write `.gitignore`, `.pre-commit-config.yaml`, `AGENTS.md`, `README.md`
4. **Install pre-commit** — `pre-commit install` and `pre-commit run --all-files` to verify
5. **Hand off** — Delegate to the language-specific skill for further setup (dependencies, config, structure)

## Files This Skill ALWAYS Creates

| File | Purpose |
|------|---------|
| `.gitignore` | Language-appropriate ignore patterns |
| `.pre-commit-config.yaml` | Automated linting, formatting, and checks |
| `AGENTS.md` | Agent instructions — project overview, key commands, conventions |
| `README.md` | Project description, setup, usage, development guide |

## .pre-commit-config.yaml Templates

### Python

```yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.11.0
    hooks:
      - id: ruff
        args: [--fix, --exit-non-zero-on-fix]
      - id: ruff-format

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.15.0
    hooks:
      - id: mypy
        additional_dependencies: [pydantic>=2.5.0]

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-toml
      - id: check-merge-conflict
      - id: check-added-large-files
        args: [--maxkb=500]
```

### Node.js / TypeScript

```yaml
repos:
  - repo: https://github.com/pre-commit/mirrors-eslint
    rev: v9.22.0
    hooks:
      - id: eslint
        additional_dependencies:
          - eslint@^9.0.0
        args: [--fix]

  - repo: https://github.com/pre-commit/mirrors-prettier
    rev: v4.0.0
    hooks:
      - id: prettier

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-merge-conflict
      - id: check-added-large-files
        args: [--maxkb=500]
```

### Go

```yaml
repos:
  - repo: https://github.com/golangci/golangci-lint
    rev: v1.64.0
    hooks:
      - id: golangci-lint

  - repo: https://github.com/TekWizely/pre-commit-golang
    rev: v1.0.0-rc.1
    hooks:
      - id: go-fmt
      - id: go-vet
      - id: go-build
      - id: go-test

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-merge-conflict
      - id: check-added-large-files
        args: [--maxkb=500]
```

### Generic (no specific language)

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-toml
      - id: check-merge-conflict
      - id: check-added-large-files
        args: [--maxkb=500]
      - id: detect-private-key
```

## .gitignore Templates

### Python

```
__pycache__/
*.py[cod]
*$py.class
*.egg-info/
dist/
build/
.eggs/
*.egg
.venv/
venv/
.env
.mypy_cache/
.ruff_cache/
.pytest_cache/
.coverage
htmlcov/
```

### Node.js / TypeScript

```
node_modules/
dist/
build/
.next/
.env
.env.local
*.tsbuildinfo
coverage/
```

### Go

```
bin/
*.exe
*.exe~
*.dll
*.so
*.dylib
vendor/
```

### Generic

```
.env
*.log
.DS_Store
Thumbs.db
```

## AGENTS.md Template

```markdown
# {project_name}

## Overview

{One-paragraph description of what this project does.}

## Key Files

| File | Purpose |
|------|---------|
| `{entry_file}` | Main entry point |
| `pyproject.toml` | Project metadata and dependencies |
| `.pre-commit-config.yaml` | Pre-commit hooks |

## Commands

| Task | Command |
|------|---------|
| Install | `{install_cmd}` |
| Run | `{run_cmd}` |
| Test | `{test_cmd}` |
| Lint | `{lint_cmd}` |
| Format | `{fmt_cmd}` |
| Type check | `{typecheck_cmd}` |

## Conventions

- **Language**: {language} {version}
- **Formatting**: {formatter}
- **Linting**: {linter}
- **Testing**: {test_framework}
- **Type checking**: {type_checker}

## Architecture

{Brief description of the project structure and design decisions.}
```

## README.md Template

```markdown
# {project_name}

> {One-line description}

## Requirements

- {language} >= {version}

## Setup

```bash
git clone {repo_url}
cd {project_name}
{install_cmd}
```

## Usage

```
{usage_example}
```

## Development

```bash
# Install dev dependencies
{install_dev_cmd}

# Run tests
{test_cmd}

# Lint
{lint_cmd}

# Format
{fmt_cmd}
```

## License

MIT
```

## Constraints

### MUST DO
- Create all 4 skeleton files (`.gitignore`, `.pre-commit-config.yaml`, `AGENTS.md`, `README.md`)
- Populate `AGENTS.md` with the project name, real commands, and real conventions
- Populate `README.md` with the project name, setup instructions, and usage
- Run `pre-commit install` after creating `.pre-commit-config.yaml`
- Run `pre-commit run --all-files` to verify hooks work
- Defer to language-specific skills for dependency management, project structure, and code generation
- Use the user's git identity for any initial commits

### MUST NOT DO
- Assume existing code, dependencies, or patterns exist
- Create language-specific source files (delegate to language skills)
- Skip pre-commit setup
- Hardcode values that should be asked of the user (project name, description, etc.)
- Create files the user didn't ask for beyond the 4 skeleton files

## Output Templates

When scaffolding a new project, provide:
1. `.gitignore` with language-appropriate patterns
2. `.pre-commit-config.yaml` with hooks matching the language stack
3. `AGENTS.md` populated with real project commands and conventions
4. `README.md` with setup, usage, and development instructions
5. Confirmation that `pre-commit install` was run
6. Suggestion to invoke the appropriate language skill for further setup

## Knowledge Reference

pre-commit, git init, .gitignore, AGENTS.md conventions, README best practices, project scaffolding, Python (pyproject.toml, ruff, mypy), Node.js (package.json, eslint, prettier), Go (go.mod, golangci-lint)
