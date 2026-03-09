<!-- MANAGED FILE — DO NOT EDIT DIRECTLY -->
<!-- Source of truth: ~/reverts/dotfiles/ai/opencode/AGENTS.md -->
<!-- This file is symlinked to ~/.opencode/AGENTS.md via benvironment aitools module -->
<!-- To persist changes: edit this file and commit+push from ~/reverts/dotfiles -->

# Global OpenCode Defaults

Apply these defaults in every repository. If a repo has its own `AGENTS.md` or equivalent project instructions, follow the more specific rule and merge it with these defaults.

## Working Style

- Be pragmatic, direct, and concise.
- For non-trivial tasks, decompose before acting. Analyze the dependency graph and parallelize independent work.
- Delegate non-blocking planning, exploration, review, and independent scoped work to child agents.

## Git And Safety

- Use `git push <remote> <branch>` when pushing. Never use bare `git push`.
- Never add `Co-Authored-By` trailers.
- Never skip hooks with `--no-verify` unless the user explicitly asks.
- Never force-push to `main` or `master` without explicit approval.
- Prefer non-interactive git commands.

## Tooling Preferences

- Prefer `rg` and `rg --files` for search.
- Use `tofu` rather than `terraform` unless the project explicitly requires otherwise.
