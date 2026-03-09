---
name: benvironment
description: Work with the benvironment project — a personal dev environment bootstrap system. Use this skill for any task involving benvironment files, tools, aliases, functions, configs, or environment setup.
argument-hint: [task description]
allowed-tools: Read, Grep, Glob, Bash
---

# Benvironment Skill

You are working with **benvironment**, a shell-based personal development environment bootstrap system located at `$HOME/reverts/benvironment`.

## Before doing anything else

Read and understand ALL relevant project files before processing the user's request. The project structure is:

### Core files (always read these first)
- `$HOME/reverts/benvironment/.benvironment` — Main environment loader, sets env vars, defines tool list, sources all modules
- `$HOME/reverts/benvironment/install-tools` — System package and tool installer for Linux
- `$HOME/reverts/benvironment/install.sh` — First-time bootstrap script

### Shell modules (read as needed based on the task)
- `$HOME/reverts/benvironment/aliases` — Shell aliases (git, navigation, terraform, etc.)
- `$HOME/reverts/benvironment/functions` — Utility bash functions (GPG, key mgmt, docker, system admin)
- `$HOME/reverts/benvironment/keyme` — SSH key management (ephemeral storage, ssh-agent)
- `$HOME/reverts/benvironment/vault` — Bitwarden credential management
- `$HOME/reverts/benvironment/colors` — ANSI color definitions and helper functions
- `$HOME/reverts/benvironment/shared` — Shared utility functions
- `$HOME/reverts/benvironment/configs` — Dotfile management and oh-my-zsh plugin setup
- `$HOME/reverts/benvironment/pull` — Git pull request helpers
- `$HOME/reverts/benvironment/statuses` — Status display functions
- `$HOME/reverts/benvironment/connect` — Connection/network utilities
- `$HOME/reverts/benvironment/livetail` — Live log tailing
- `$HOME/reverts/benvironment/tmux` — Tmux configuration
- `$HOME/reverts/benvironment/vim` — Vim setup
- `$HOME/reverts/benvironment/azure` — Azure CLI integration
- `$HOME/reverts/benvironment/bitwarden` — Bitwarden integration
- `$HOME/reverts/benvironment/mfa` — MFA/2FA configuration
- `$HOME/reverts/benvironment/awskeys` — AWS key management
- `$HOME/reverts/benvironment/aes` — AES encryption utilities
- `$HOME/reverts/benvironment/gpw` — Password generation
- `$HOME/reverts/benvironment/clone` — Repository cloning helpers
- `$HOME/reverts/benvironment/links` — Symlink management
- `$HOME/reverts/benvironment/kubernetes` — Kubernetes utilities
- `$HOME/reverts/benvironment/open` — URL/app opening helpers
- `$HOME/reverts/benvironment/localuser` — Local user configuration
- `$HOME/reverts/benvironment/localuser.sh` — Local user setup script

### Tool installers (in tools/ directory)
- `$HOME/reverts/benvironment/tools/nodejs` — Node.js
- `$HOME/reverts/benvironment/tools/fzf` — Fuzzy finder
- `$HOME/reverts/benvironment/tools/bw` — Bitwarden CLI
- `$HOME/reverts/benvironment/tools/docker` — Docker
- `$HOME/reverts/benvironment/tools/docker-compose` — Docker Compose
- `$HOME/reverts/benvironment/tools/tidy-markdown` — Markdown formatter
- `$HOME/reverts/benvironment/tools/prettyping` — Pretty ping
- `$HOME/reverts/benvironment/tools/kitty` — Kitty terminal
- `$HOME/reverts/benvironment/tools/lpass` — LastPass CLI
- `$HOME/reverts/benvironment/tools/claude-code` — Claude Code CLI
- `$HOME/reverts/benvironment/tools/granted` — AWS Granted SSO tool

### Testing and build
- `$HOME/reverts/benvironment/test/test.sh` — Test suite
- `$HOME/reverts/benvironment/test/Dockerfile` — Test container
- `$HOME/reverts/benvironment/Dockerfile` — Main container definition
- `$HOME/reverts/benvironment/.dev/build.sh` — Build script
- `$HOME/reverts/benvironment/.dev/run.sh` — Run script

## Project conventions

- Files are bash scripts (sourced, not executed directly)
- Environment variables are uppercase: `BENVIRONMENT_*`, `DIR_*`, `URL_*`
- Internal helper functions are prefixed with underscore: `_which()`, `_keyme_validate_dir()`
- Color output uses exported variables: `${red}`, `${green}`, `${blue}`, etc.
- Tool installers are idempotent (check `_which` before installing)
- `BENVIRONMENT_TOOLS_LIST` in `.benvironment` controls which tools get installed
- `BENVIRONMENT_FILES_TO_LOAD` in `.benvironment` controls which modules get sourced
- Git commits never include Co-Authored-By lines
- **Always commit and push after making changes to benvironment.** After any file edit, stage, commit, and `git push origin master` from the benvironment repo directory.

## Pre-populated knowledge (verify on change)

- Start environment investigations in `$HOME/reverts/benvironment/.benvironment` first.
- `.benvironment` sets `URL_PATH_TO_ENV_FILES` to `https://raw.githubusercontent.com/bhudgens/benvironment/master`.
- `.benvironment` defaults `BENVIRONMENT_FILES_TO_LOAD` to: `colors aes shared configs tmux vim install-tools functions aliases pull statuses keyme azure livetail bitwarden mfa camera connect localuser links awskeys fonts clone kubernetes raspberrypi vault gpw`.
- `.benvironment` defaults `BENVIRONMENT_TOOLS_LIST` to: `nodejs fzf bw docker docker-compose tidy-markdown prettyping kitty lpass claude-code granted aichat opencode`.
- `configs` ensures dotfiles repo exists at `$HOME/.dotfiles`, pulls latest, and installs `.zshrc` and `.tmux.conf` via `install_dot_file`.
- `shared` function `install_dot_file` creates symlinks in `$HOME` and backs up existing files to `*.bak`.
- Tmux module file is `$HOME/reverts/benvironment/tmux`; it installs TPM and defines helper functions `ta` and `ide`.
- Active tmux config is expected at `~/.tmux.conf`, normally symlinked to `$HOME/.dotfiles/.tmux.conf`.
- Current tmux prefix in dotfiles tmux config is `C-a` (with `C-b` unbound).
- Dotfiles tmux config includes: vi mode keys, mouse on, `|`/`-` split binds, `prefix+r` reload, vim-aware pane navigation, history limit `50000`, and TPM plugins `tmux-plugins/tpm`, `tmux-plugins/tmux-resurrect`, `tmux-plugins/tmux-yank`.
- Install flow: `install.sh` bootstraps core deps and oh-my-zsh, writes `.benvironment` to home, and appends `source .benvironment` to `~/.zshrc`.
- Linux installer `install-tools` installs core packages via apt, ensures `bat`/`ripgrep`, installs AWS CLI v2, fetches tool scripts into `$HOME/run/tools`, then sources them.
- Prefer `tofu` over `terraform` for IaC guidance even if legacy aliases mention terraform.

## Response behavior requirements

- For environment questions, read `$HOME/reverts/benvironment/.benvironment` first, then relevant modules.
- For tmux questions, always read and reference:
  - `$HOME/reverts/benvironment/.benvironment`
  - `$HOME/reverts/benvironment/configs`
  - `$HOME/reverts/benvironment/shared`
  - `$HOME/reverts/benvironment/tmux`
  - `$HOME/.dotfiles/.tmux.conf` (or resolved target of `~/.tmux.conf`)
- If there is any mismatch between pre-populated knowledge and current files, trust current files and call out the delta.

## Your task

$ARGUMENTS
