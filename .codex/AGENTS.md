<!-- MANAGED FILE — DO NOT EDIT ~/.codex/AGENTS.md DIRECTLY -->
<!-- Source of truth: ~/reverts/dotfiles/.codex/AGENTS.md -->
<!-- Copied to ~/.codex/AGENTS.md on every shell load by benvironment aitools -->
<!-- Local edits are overwritten on next shell load -->
<!-- To persist changes: edit ~/reverts/dotfiles/.codex/AGENTS.md and commit+push -->

# Global Codex Defaults

Apply these defaults in every repository. If a repo has its own `AGENTS.md`, `CLAUDE.md`, or equivalent project instructions, follow the more specific rule and merge it with these defaults.

## Working Style

- Be pragmatic, direct, and concise.
- Keep the main thread focused on user intent, decisions, and final synthesis.
- For non-trivial tasks, explicitly consider a multi-agent decomposition before acting.
- Analyze the dependency graph first. Parallelize independent reads, searches, git commands, verification, and agent work.
- Keep urgent critical-path blockers local when delegation would slow progress.
- Delegate non-blocking planning, exploration, review, repeated audits, and independent scoped work to child agents.

## Default Team Shape

- `planner`: read-only planning, decomposition, file-path discovery, command planning, acceptance criteria.
- `implementer`: complex code changes and judgment-heavy implementation.
- `executor`: straightforward edits, commands, and targeted verification.
- `reviewer`: adversarial final review focused on bugs, regressions, missing tests, and unsafe assumptions.

## Multi-Agent Expectations

- On substantial work, prefer a planner pass before broad implementation.
- Give child agents exact scopes, file paths, constraints, and expected output format.
- Ask child agents for concise summaries rather than raw transcripts.
- Prefer read-only child agents unless they need to edit files.
- Avoid multiple write-enabled agents touching the same files at the same time.
- Before finalizing substantial changes, run a reviewer pass when practical.

## Validation

- Prefer tool-backed validation over prompt-only confidence.
- Define acceptance criteria early.
- For code tasks, write or update tests first where practical.
- Run targeted verification after changes and report exact results or blockers.
- Call out missing tests, residual risks, and unverified assumptions explicitly.

## Git And Safety

- Use `git push <remote> <branch>` when pushing. Never use bare `git push`.
- Never add `Co-Authored-By` trailers.
- Never skip hooks with `--no-verify` unless the user explicitly asks.
- Never force-push to `main` or `master` without explicit approval.
- Respect dirty worktrees. Never revert unrelated user changes.
- Prefer non-interactive git commands.

## Tooling Preferences

- Prefer `rg` and `rg --files` for search.
- Use primary official sources for changing libraries, APIs, or product behavior.
- Use `tofu` rather than `terraform` unless the project explicitly requires otherwise.
