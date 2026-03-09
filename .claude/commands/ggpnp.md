# ggpnp - Small Commits, Pull, and Push

Analyze all uncommitted changes, group them into small isolated commits (each easily revertable), pull from origin, then push to origin on the current branch.

## Steps

1. Run `git status` (no `-uall` flag) to see untracked and modified files.
2. Run `git diff` to see staged and unstaged changes.
3. Run `git log --oneline -5` to see recent commit message style.
4. Analyze ALL uncommitted changes and group them into small, logically isolated commits. Each commit should:
   - Cover a single logical change (one bug fix, one feature, one refactor, one config change, etc.)
   - Be independently revertable without breaking other changes
   - Never mix unrelated changes in the same commit
5. For each logical group, in sequence:
   a. Stage only the files belonging to that group by name (never `git add -A`).
   b. Draft a concise commit message:
      - Summarize the nature of the change (new feature, enhancement, bug fix, refactoring, etc.)
      - Focus on the "why" rather than the "what"
      - Keep it to 1-2 sentences
      - NEVER add Co-Authored-By lines
      - Do not commit files that likely contain secrets (.env, credentials, etc.)
   c. Create the commit using a HEREDOC for the message.
6. Determine the current git branch name.
7. Run `git pull origin <branch>` to pull latest changes.
8. Run `git push origin <branch>` to push local commits.

Always use explicit remote (`origin`) and branch name. Never use bare `git push` or `git pull`.
