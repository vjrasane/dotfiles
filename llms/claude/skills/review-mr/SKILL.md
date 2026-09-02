---
name: review-mr
description: Find the GitLab merge request for the current jj branch and run a code review on it. Use when the user wants to review the MR, review the merge request, review "my MR", or review the current branch's changes on GitLab.
allowed-tools: Bash, Read, Grep, Glob, Task, mcp__plugin_claude-code-home-manager_gitlab__list_merge_requests, mcp__plugin_claude-code-home-manager_gitlab__get_merge_request, mcp__plugin_claude-code-home-manager_gitlab__get_merge_request_diffs, mcp__plugin_claude-code-home-manager_gitlab__create_merge_request_note, mcp__claude_ai_Linear__get_issue
---

# Review MR

Locate the GitLab merge request for the current branch, then review its diff.

## Instructions

### Step 1: Identify the branch and ticket

Gather signals to identify the MR. The MR's **source branch** is the strongest key.

```bash
# Nearest pushed bookmark on the current change (the likely source branch)
jj log -r '@' --no-graph -T 'bookmarks'
# Fall back to bookmarks on ancestors if @ has none
jj log -r 'ancestors(@) & bookmarks()' --limit 3 --no-graph \
  -T 'bookmarks ++ " " ++ change_id.short() ++ "\n"'
# Change descriptions may reference a Linear ticket (e.g. ENG-1234)
jj log -r '@ | @-' --no-graph -T 'description ++ "\n"'
# Confirm the GitLab remote
jj git remote list
```

Extract a **Linear ticket id** (pattern like `ABC-123`) from the branch name or descriptions if present.

### Step 2: Find the MR

Identify the project by its GitLab remote URL, then locate the MR by source branch:

1. `mcp__plugin_claude-code-home-manager_gitlab__list_merge_requests` with `scope: created_by_me`, `state: opened`, passing the project `url`. Match a result whose source branch equals the branch from Step 1.
2. If no match, retry with `search` set to the Linear ticket id, then to the branch name.
3. If still ambiguous, list open MRs and ask the user to confirm which one.

Optionally cross-check via Linear: `mcp__claude_ai_Linear__get_issue` on the ticket id — its links/attachments often point at the MR.

### Step 3: Fetch the diff

Once the MR iid is known:

```
mcp__plugin_claude-code-home-manager_gitlab__get_merge_request        # metadata (title, description, source/target)
mcp__plugin_claude-code-home-manager_gitlab__get_merge_request_diffs  # patch text
```

### Step 4: Run the review

Dispatch the `code-reviewer` agent with the MR title, description, and full diff text embedded in the prompt (the agent has no MCP access — it must receive the diff inline). Review for:

- Correctness and edge cases
- Security (injection, secrets exposure, auth)
- Performance
- Readability and consistency with the codebase

Present findings grouped as **must-fix** vs **suggestions**, each pointing to `file:line`.

### Step 5: Offer to post (optional)

Ask whether to post the review back to the MR. Only if the user confirms, use `mcp__plugin_claude-code-home-manager_gitlab__create_merge_request_note`. Never post without explicit confirmation.

## Failure handling

- **No bookmark on `@`**: walk ancestors, or ask the user for the branch name.
- **Remote is GitHub, not GitLab**: this skill targets GitLab MRs — stop and say so.
- **Multiple open MRs match**: present them and let the user pick.
