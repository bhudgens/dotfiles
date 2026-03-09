# Review Project Board

You are a code reviewer for the Ordino project. Your job is to review all items currently in the "In review" column of the GitHub Project board, perform deep code reviews, and either approve+merge or kick back with documented concerns.

## Prerequisites

- You need `gh` CLI authenticated with access to `bhudgens/ordino`
- You need a **review checkout** directory separate from any implementation checkout to avoid git conflicts with other AI agents

## Step 0: Set Up Review Directory

Check if a review checkout exists. If not, create one:

```bash
# Check for existing review checkout
REVIEW_DIR="$(git rev-parse --show-toplevel 2>/dev/null)/../review"
if [ ! -d "$REVIEW_DIR/.git" ]; then
  echo "No review checkout found at $REVIEW_DIR"
  echo "Creating one..."
  git clone https://github.com/bhudgens/ordino.git "$REVIEW_DIR"
fi
```

**All review work MUST happen in the review checkout directory.** Never review from an implementation directory where other agents may be working.

## Step 1: Pull Latest in Review Checkout

```bash
cd "$REVIEW_DIR" && git checkout main && git pull origin main
```

## Step 2: Query the Project Board for "In Review" Items

Use the GitHub Projects API to find items in the "In review" column:

```bash
gh project item-list 4 --owner bhudgens --format json
```

Filter for items with Status = "In review". The GitHub Project board uses these IDs:
- **Project ID**: `PVT_kwHOAHoJ_M4BPmyl`
- **Status Field ID**: `PVTSSF_lAHOAHoJ_M4BPmylzg994Tc`
- **Column Option IDs**:
  - Backlog: `f75ad846`
  - Ready: `61e4505c`
  - In progress: `47fc9ee4`
  - In review: `df73e18b`
  - Done: `98236657`

If no items are in "In review", report that the review queue is empty and stop.

## Step 3: For Each "In Review" Item — Deep Review

For each issue in the "In review" column:

### 3a. Gather Context

1. **Read the issue** — get the full issue body, especially acceptance criteria checkboxes:
   ```bash
   gh issue view <NUMBER> --repo bhudgens/ordino
   ```

2. **Read all issue comments** — check for implementation notes, design decisions, and any unresolved discussions:
   ```bash
   gh issue view <NUMBER> --repo bhudgens/ordino --comments
   ```

3. **Find the associated PR** — look for linked PRs or search:
   ```bash
   gh pr list --repo bhudgens/ordino --state open --search "fixes #<NUMBER> OR closes #<NUMBER>"
   ```

4. **Read the PR** — get the PR description and all comments:
   ```bash
   gh pr view <PR_NUMBER> --repo bhudgens/ordino
   gh pr view <PR_NUMBER> --repo bhudgens/ordino --comments
   ```

5. **Check for unresolved PR review comments**:
   ```bash
   gh api repos/bhudgens/ordino/pulls/<PR_NUMBER>/comments
   gh api repos/bhudgens/ordino/pulls/<PR_NUMBER>/reviews
   ```

### 3b. Code Review

1. **Checkout the PR branch in the review directory**:
   ```bash
   cd "$REVIEW_DIR"
   gh pr checkout <PR_NUMBER>
   ```

2. **See all changed files**:
   ```bash
   gh pr diff <PR_NUMBER> --repo bhudgens/ordino
   ```

3. **Read every changed file in full** — do not just skim the diff. Read the complete files to understand context. Use the Read tool for each file.

4. **Run the full validation suite**:
   ```bash
   cd "$REVIEW_DIR"
   npm install
   npm run build --workspaces
   npm run lint --workspaces
   npm run test --workspaces
   ```

5. **Audit each acceptance criterion** from the issue against the actual code:
   - For each checkbox item in the issue body, verify the code actually implements it
   - Check edge cases and error handling
   - Verify test coverage for the criterion

### 3c. Review Checklist

Check ALL of the following:

- [ ] **Acceptance criteria**: Every checkbox item in the issue is actually implemented and working
- [ ] **Build passes**: `npm run build --workspaces` succeeds
- [ ] **Lint passes**: `npm run lint --workspaces` succeeds
- [ ] **Tests pass**: `npm run test --workspaces` succeeds
- [ ] **Tests exist**: New behavior has test coverage
- [ ] **Code style**: 2-space indent, single quotes, no semicolons, no `any`, no casual `console.log`
- [ ] **Named exports**: New modules use named exports (not default exports)
- [ ] **TypeScript strict**: No type safety bypasses (`as` casts, `any`, `@ts-ignore`) without justification
- [ ] **Security**: No secrets committed, input validation at boundaries, JWT verification intact
- [ ] **API compatibility**: `/v1/*` endpoint behavior preserved
- [ ] **No unresolved comments**: All PR comments and issue threads are resolved
- [ ] **Architecture alignment**: Changes align with CLAUDE.md, AGENTS.md, and .ai/ARCHITECTURE.md

## Step 4: Decision — Approve or Kick Back

### If ALL criteria pass and no concerns:

1. **Check off all acceptance criteria** on the issue body:
   ```bash
   # Get the current issue body, update checkboxes from [ ] to [x], then update
   gh issue edit <NUMBER> --repo bhudgens/ordino --body "updated body with checked boxes"
   ```

2. **Post an approval comment on the PR** summarizing what was verified:
   ```bash
   gh pr comment <PR_NUMBER> --repo bhudgens/ordino --body "Review complete. All acceptance criteria verified: [list what was checked]. Build, lint, and tests pass. Approving and merging."
   ```

3. **Post a summary comment on the issue**:
   ```bash
   gh issue comment <NUMBER> --repo bhudgens/ordino --body "All acceptance criteria verified during review. Merging PR #<PR_NUMBER>."
   ```

4. **Merge the PR**:
   ```bash
   gh pr merge <PR_NUMBER> --repo bhudgens/ordino --merge --delete-branch
   ```

5. **Verify the issue auto-closed** (if the PR commit message had `fixes #N`). If not, close it manually:
   ```bash
   gh issue close <NUMBER> --repo bhudgens/ordino
   ```

6. **Move the board item to Done**:
   ```bash
   # Get the item ID from the project board
   gh project item-list 4 --owner bhudgens --format json | jq -r '.items[] | select(.content.number == <NUMBER>) | .id'
   # Move to Done
   gh project item-edit --project-id PVT_kwHOAHoJ_M4BPmyl --id <ITEM_ID> --field-id PVTSSF_lAHOAHoJ_M4BPmylzg994Tc --single-select-option-id 98236657
   ```

### If ANY issue is found (including nitpicks):

**You MUST reject the review for ANY issue, no matter how small.** Nitpicks are not optional — they must be addressed or explicitly discussed.

1. **Post a detailed review comment on the PR** listing every concern:
   ```bash
   gh pr comment <PR_NUMBER> --repo bhudgens/ordino --body "## Review: Changes Requested

   [List each concern with:]
   - File path and line numbers
   - What the issue is
   - Why it matters
   - Suggested fix (if applicable)

   These must be addressed before merging. Please fix or discuss in this thread."
   ```

2. **Post a summary comment on the issue** so it's visible on the kanban board:
   ```bash
   gh issue comment <NUMBER> --repo bhudgens/ordino --body "Review of PR #<PR_NUMBER> found issues that need to be addressed: [brief summary]. Moving back to Ready for re-work. See PR comments for details."
   ```

3. **Do NOT check off unverified acceptance criteria** — leave unchecked boxes unchecked.

4. **Move the board item back to Ready** (NOT Backlog, NOT In progress):
   ```bash
   # Get the item ID
   gh project item-list 4 --owner bhudgens --format json | jq -r '.items[] | select(.content.number == <NUMBER>) | .id'
   # Move to Ready
   gh project item-edit --project-id PVT_kwHOAHoJ_M4BPmyl --id <ITEM_ID> --field-id PVTSSF_lAHOAHoJ_M4BPmylzg994Tc --single-select-option-id 61e4505c
   ```

5. **Leave the PR open** so the implementer can iterate on it.

## Critical Rules

1. **NEVER merge with known issues.** Even small nitpicks must be fixed or explicitly discussed and deferred with a follow-up issue created.

2. **All discussion happens on GitHub.** Post concerns as PR comments or issue comments — never resolve things in ephemeral agent sessions. This creates an auditable trail.

3. **Check ALL existing comments before approving.** If there are unresolved PR review comments or issue thread discussions, the review MUST fail even if the code looks fine.

4. **Reviewer must have fresh eyes.** This skill is designed to be run in a fresh session without context from the implementation. Read everything from GitHub — don't rely on any prior session knowledge.

5. **Kick backs go to Ready column.** When rejecting, move to Ready (not Backlog) so the implementing agent picks it back up. The PR stays open for iteration.

6. **Never push directly to main.** If you find a trivial fix you want to make yourself, push it to the existing PR branch, not main.

7. **One review pass per run.** Review all items in "In review" in a single run, posting comments and moving board items as you go.

## Final Report

After reviewing all items, output a summary:
- How many items were in the review queue
- For each item: issue number, PR number, verdict (approved+merged OR kicked back), and brief reason
- Any items that need attention from the project owner
