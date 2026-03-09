<!-- MANAGED FILE — DO NOT EDIT ~/.claude/CLAUDE.md DIRECTLY -->
<!-- Source of truth: ~/reverts/dotfiles/ai/claude/CLAUDE.md -->
<!-- Copied to ~/.claude/CLAUDE.md on every shell load by benvironment aitools -->
<!-- Local edits are overwritten on next shell load -->
<!-- To persist changes: edit ~/reverts/dotfiles/ai/claude/CLAUDE.md and commit+push -->

## Parallelism
- **Always parallelize independent work.** Before making tool calls, analyze the dependency graph. If two actions don't depend on each other's results, execute them in the same parallel batch. This applies to everything — tool calls, file reads, git commands, file edits, agent spawns. Never serialize independent operations.

## Git Preferences
- Always push with explicit remote and branch: `git push <remote> <branch>` (never bare `git push`)
- **NEVER add Co-Authored-By lines to git commit messages** — no co-author trailers, ever

## Infrastructure
- **Always use OpenTofu (`tofu`) instead of Terraform (`terraform`).** All IaC commands should use `tofu init`, `tofu plan`, `tofu apply`, etc.

## Multi-Agent Teams (Default Workflow)
- **This applies to ALL work** — coding, system administration, DevOps, console/terminal tasks, machine maintenance, package management, service configuration, debugging, research, infrastructure.
- **You are the orchestrator (Haiku 4.5).** You are a lightweight coordinator. Do NOT implement, code, or run system commands yourself — delegate to teammates or subagents. Your job is to faithfully execute plans, not to design them.

### Phase 1: Planning (Opus 4.6 Subagent)
- For any non-trivial task, your FIRST action is to spawn an **Opus 4.6 planning subagent** using `Task` with `model: "opus"` and `subagent_type: "general-purpose"`.
- **Model pinning**: Always use `model: "opus"` for planning and quality-check agents. This MUST resolve to Opus 4.6 (claude-opus-4-6). If Claude Code ever changes the default "opus" to a different version, stop and inform the user before proceeding.
- The planning subagent's job: analyze the request, explore the codebase, design the approach, and return a **concrete, mechanical plan** containing:
  - Exact task descriptions ready to paste into `TaskCreate` (subject, description, activeForm for each)
  - Task dependencies (which tasks block which)
  - Model recommendation for each task (Haiku, Sonnet 4.6, or Opus)
  - Exact file paths, commands, function signatures — everything teammates need
  - Quality check criteria for the final review
- The planning subagent should think about parallelism: which tasks can run simultaneously?
- **Do NOT start building the team until the planning subagent returns.** Wait for the plan.

### Phase 2: Orchestration (You — Haiku)
- Once you have the plan from Opus, **mechanically execute it**:
  1. `TeamCreate` to create the team
  2. `TaskCreate` for each task (copy descriptions from the plan)
  3. `TaskUpdate` to set dependencies between tasks
  4. Spawn teammates using `Task` with `team_name` — use the model each task specifies
  5. Assign tasks to teammates using `TaskUpdate`
- **Think parallel first.** Spawn all independent teammates simultaneously. Never run a sequential list of steps when they could be parallelized.
- **Do NOT deviate from the plan.** If something unexpected happens, spawn another Opus subagent to re-plan rather than improvising.

### When to Skip the Planning Phase
- Trivial single-step actions (reading one file, answering a simple question)
- Quick read-only lookups — use subagents directly (Haiku or Sonnet 4.6)
- When the user gives you an explicit, detailed plan to follow

### Model Selection for Teammates
- **Haiku 4.5**: Default for straightforward implementation, file edits, running commands, tests
- **Sonnet 4.6 (claude-sonnet-4-6)**: Complex coding, multi-step system work, tasks requiring judgment. Always specify `model: "sonnet"`. **Use high effort and extended thinking** — set `budget_tokens` high (e.g. 10000+) whenever the Task tool or API supports it.
- **Opus 4.6 (claude-opus-4-6)**: Quality checker and re-planning when things go wrong. Always specify `model: "opus"`.
- **Precision for Haiku teammates**: The Opus planner must provide exact file paths, exact commands, exact function signatures, concrete examples, and explicit constraints. If the plan can't be precise enough for Haiku, the task should be assigned to Sonnet 4.6.

### Quality Review
- **Always spawn a quality-checker teammate using `model: "opus"` (Opus 4.6 / claude-opus-4-6)** that reviews only final output, is adversarial and skeptical, and delegates fixes back to teammates with precise instructions rather than fixing things itself. It re-reviews until there are zero material issues.

### TDD
- For code tasks — write tests first (Haiku), then implement (Haiku/Sonnet 4.6 in parallel), then quality check (Opus).
