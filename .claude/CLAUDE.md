<!-- MANAGED FILE — DO NOT EDIT ~/.claude/CLAUDE.md DIRECTLY -->
<!-- Source of truth: ~/reverts/dotfiles/.claude/CLAUDE.md -->
<!-- Copied to ~/.claude/CLAUDE.md on every shell load by benvironment aitools -->
<!-- Local edits are overwritten on next shell load -->
<!-- To persist changes: edit ~/reverts/dotfiles/.claude/CLAUDE.md and commit+push -->

## Parallelism
- **Always parallelize independent work.** Before making tool calls, analyze the dependency graph. If two actions don't depend on each other's results, execute them in the same parallel batch. This applies to everything — tool calls, file reads, git commands, file edits, agent spawns. Never serialize independent operations.

## Git Preferences
- Always push with explicit remote and branch: `git push <remote> <branch>` (never bare `git push`)
- **NEVER add Co-Authored-By lines to git commit messages** — no co-author trailers, ever

## Infrastructure
- **Always use OpenTofu (`tofu`) instead of Terraform (`terraform`).** All IaC commands should use `tofu init`, `tofu plan`, `tofu apply`, etc.

## Multi-Agent Workflow

For any non-trivial task, use the `Agent` tool to spawn subagents. Parallelize independent work.

### Phase 1: Planning
- Spawn an **Opus 4.6 planning subagent** (`subagent_type: "general-purpose"`) to analyze the request, explore the codebase, and design a concrete plan before acting.
- The planning subagent should return: exact file paths, commands, function signatures, task breakdown with dependencies, and acceptance criteria.
- Wait for the plan before spawning implementation subagents.

### Phase 2: Execution
- Spawn implementation subagents in parallel for independent work — all independent `Agent` calls go in a single message.
- If something unexpected happens mid-execution, spawn another Opus subagent to re-plan rather than improvising.

### When to Skip the Planning Phase
- Trivial single-step actions (reading one file, answering a simple question)
- Quick read-only lookups
- When the user provides an explicit, detailed plan

### Model Selection for Subagents
- **Haiku 4.5**: Default for straightforward implementation, file edits, running commands, tests
- **Sonnet 4.6 (claude-sonnet-4-6)**: Complex coding, multi-step system work, tasks requiring judgment. Use high effort and extended thinking when supported.
- **Opus 4.6 (claude-opus-4-6)**: Planning and quality review.

### Quality Review
- Spawn an Opus 4.6 subagent as quality checker on final output. It should be adversarial and skeptical — flagging issues with precise file references rather than fixing them itself. Re-review until no material issues remain.

### TDD
- For code tasks: write tests first, then implement (parallel subagents where possible), then quality check (Opus).

## User Environment
- Running **Kubuntu** (KDE-flavored Ubuntu) as desktop Linux distribution
