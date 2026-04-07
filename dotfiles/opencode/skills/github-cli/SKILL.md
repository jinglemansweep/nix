---
name: github-cli
description: Structured interface for GitHub operations using the gh CLI
allowed-tools: Bash
---

<!-- tags: github, pr, issue, ci, workflow, gh -->
<!-- category: git-tools -->

# github-cli

Structured interface for common GitHub operations using the `gh` CLI. Covers pull requests, issues, CI/workflow runs, and GitHub API queries.

## When to Use

Use this skill for **GitHub remote operations**:

- Pull request management (list, view, create, merge, review)
- Issue management (list, create, close, view)
- CI/workflow operations (view status, logs, re-run)
- GitHub API queries for operations not covered above

## When NOT to Use

Do **not** use this skill for **local git operations**:

- `git commit`, `git push`, `git pull`, `git branch`, `git rebase`, `git merge`
- Local repository management is standard git usage and does not need this skill

## Instructions

### Pull Request Management

#### List PRs

```bash
gh pr list                          # open PRs
gh pr list --state all              # all PRs
gh pr list --author @me             # your PRs
gh pr list --json number,title,url  # machine-readable output
```

#### View PR Details

```bash
gh pr view <number>                 # summary in terminal
gh pr view <number> --json title,body,reviews,mergeable
gh pr diff <number>                 # view the diff
gh pr checks <number>               # view CI check status
```

#### View PR Comments

```bash
gh api repos/{owner}/{repo}/pulls/<number>/comments  # review comments
gh api repos/{owner}/{repo}/issues/<number>/comments  # general comments
```

#### Create a PR

```bash
gh pr create --title "Title" --body "Description"
gh pr create --title "Title" --body "Description" --base main
gh pr create --draft                # create as draft
gh pr create --fill                 # auto-fill from commits
```

#### Merge a PR

```bash
gh pr merge <number>                # interactive merge
gh pr merge <number> --squash       # squash merge
gh pr merge <number> --rebase       # rebase merge
gh pr merge <number> --merge        # merge commit
gh pr merge <number> --auto         # enable auto-merge when checks pass
```

#### Review a PR

```bash
gh pr review <number> --approve
gh pr review <number> --request-changes --body "Feedback"
gh pr review <number> --comment --body "Note"
```

### Issue Management

#### List Issues

```bash
gh issue list                              # open issues
gh issue list --state all                  # all issues
gh issue list --label "bug"                # filter by label
gh issue list --json number,title,labels   # machine-readable
```

#### View Issue Details

```bash
gh issue view <number>
gh issue view <number> --json title,body,comments,labels
```

#### Create an Issue

```bash
gh issue create --title "Title" --body "Description"
gh issue create --title "Title" --body "Description" --label "bug"
gh issue create --title "Title" --assignee @me
```

#### Close an Issue

```bash
gh issue close <number>
gh issue close <number> --reason "completed"
gh issue close <number> --reason "not planned"
```

### CI/Workflow Operations

#### View Workflow Run Status

```bash
gh run list                                # recent runs
gh run list --workflow <filename>           # runs for a specific workflow
gh run list --json databaseId,status,conclusion,name
gh run view <run-id>                       # detailed run info
```

#### View Run Logs

```bash
gh run view <run-id> --log                 # full logs
gh run view <run-id> --log-failed          # only failed step logs
```

#### Re-run Workflows

```bash
gh run rerun <run-id>                      # re-run all jobs
gh run rerun <run-id> --failed             # re-run only failed jobs
```

#### Watch a Run

```bash
gh run watch <run-id>                      # watch until completion
```

### GitHub API Queries

For operations not covered by the commands above, use `gh api` directly:

```bash
gh api repos/{owner}/{repo}                               # repo info
gh api repos/{owner}/{repo}/releases/latest                # latest release
gh api repos/{owner}/{repo}/actions/workflows              # list workflows
gh api repos/{owner}/{repo}/branches --jq '.[].name'       # branch names
```

Use `--jq` for filtering JSON output:

```bash
gh api repos/{owner}/{repo}/pulls --jq '.[].title'
```

Use `-X POST` for write operations:

```bash
gh api repos/{owner}/{repo}/labels -f name="priority" -f color="ff0000"
```

## Guidelines

- **Prefer `--json` for machine-readable output** when parsing results programmatically. Combine with `--jq` for filtering.
- **Use `gh api` as a fallback** for any GitHub operation not covered by the dedicated `gh` subcommands.
- **Never hardcode owner/repo** when running from within a git repository -- `gh` infers the repo from the git remote automatically.
- **Check `gh auth status`** if commands fail with authentication errors.
