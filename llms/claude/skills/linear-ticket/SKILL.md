---
name: linear-ticket
description: Create and maintain Linear issues through the Linear MCP, keeping descriptions short and factual and expressing connections as Linear relations instead of prose. Use when the user asks to create, file, open, or update a Linear ticket/issue, or to link, block, assign, or re-scope one. Supports a fast-path for small tickets and an interactive path that confirms team and project.
allowed-tools: AskUserQuestion, mcp__plugin_hm_linear, mcp__claude_ai_Linear, Read, Grep, Glob
argument-hint: <what the ticket is about; add "quick"/"small" to skip questions>
---

# Linear Ticket

Create and edit Linear issues. The tracker is the source of truth, not the description.
Structure the issue with Linear's own fields — team, project, relations, assignee, priority,
labels — and keep the written description short and literal.

## Core principles

- **The description states scope, nothing more.** One or two sentences on what the work is,
  and a short list only if the task genuinely has discrete parts. No "Next steps",
  "Acceptance criteria", "Verification", "Context", or "Related tickets" sections unless the
  user gave that content explicitly.
- **Never invent.** Do not add verification steps, follow-ups, acceptance criteria, rollout
  notes, or assumptions the user did not state. If a detail wasn't given, it doesn't go in.
- **Connections are relations, not links.** Express "related to", "blocks", "blocked by",
  "parent", and "duplicate of" with Linear's relation fields on `save_issue`
  (`relatedTo`, `blocks`, `blockedBy`, `parentId`, `duplicateOf`) — not as Markdown links
  pasted into the description body.
- **Set only what was specified.** Assignee, priority, labels, estimate, cycle, and relations
  are set only when the user named them. Don't prompt for fields the user didn't mention, and
  don't guess defaults.
- **Resolve from the workspace.** Read teams/projects live each time; there are no hardcoded
  defaults. Pass human names (team name, project name, user name/email/"me") to the tools —
  they resolve names, not just IDs.

Tool names below are the Linear MCP suffixes (`list_teams`, `save_issue`, …); use whichever
Linear server is available in the session.

## Choosing the path

**Fast-path** — the request contains explicit words like "quick", "small", "fast", "just
create", "no questions", or "don't ask". Skip confirmation and create immediately. Team is
still required: if the request names or clearly implies one, use it; only when team is
genuinely unresolvable do you ask that single question.

**Interactive** — everything else. Resolve and confirm **team and project** before creating.
Do not interrogate the user on other fields; set assignee/priority/labels/relations only from
what they already said.

## Interactive workflow

1. **Resolve team.** `list_teams`. If the request names a team, match it. If one team exists
   or context makes it obvious, use it. Otherwise ask.
2. **Resolve project.** `list_projects` (filter by the chosen team). Match a named project, or
   confirm "no project" is intended. A ticket without a project is fine when the user says so
   or no project fits — don't force one.
3. **Confirm team + project** with the user when either was inferred rather than stated. Use
   `AskUserQuestion` with the concrete candidates. Don't bundle in questions about fields the
   user didn't raise.
4. **Draft the title and description.** Title: a short imperative phrase. Description: see
   *Writing the description*. If the user mentioned related/blocking issues, resolve those
   identifiers now (`list_issues` or `get_issue` to confirm they exist).
5. **Create** with `save_issue` — `team`, `title`, `description`, plus only the fields the user
   specified (`project`, `assignee`, `priority`, `labels`, `relatedTo`, `blocks`, `blockedBy`,
   `parentId`, `duplicateOf`, `estimate`, `cycle`).
6. **Report** the created identifier and URL in one line. Don't restate the description back.

## Fast-path workflow

1. Determine team (from request/context; ask only if unresolvable).
2. `save_issue` with `team`, `title`, `description`, and any field the request stated.
3. Report identifier and URL.

## Writing the description

Good (scope only):

```
Rotate the S3 access keys used by the ingestion workers and update the secret in Vault.
```

With genuinely discrete parts the user described:

```
Split the billing webhook handler into its own service.

- Extract the handler and its tests
- Point the webhook route at the new service
```

Avoid — padding the model added on its own:

```
## Context
As part of our ongoing reliability work...     ← not stated by the user
## Acceptance criteria
- [ ] Keys rotated and verified in staging      ← invented verification
## Next steps
- Follow up with a ticket for monitoring         ← invented follow-up
## Related
- See LIN-412, LIN-419                            ← belongs in relatedTo, not prose
```

If the user explicitly provided acceptance criteria, context, or steps, include exactly that —
in their words, trimmed — and nothing more.

## Relations

Set relations on `save_issue` by issue identifier (e.g. `LIN-123`). These arrays are
append-only — they never remove existing relations.

| Intent | Field |
|---|---|
| this relates to X | `relatedTo: ["LIN-X"]` |
| this blocks X | `blocks: ["LIN-X"]` |
| this is blocked by X | `blockedBy: ["LIN-X"]` |
| sub-issue of X | `parentId: "LIN-X"` |
| duplicate of X | `duplicateOf: "LIN-X"` |

When the user references a related issue by title or description rather than identifier, find
it with `list_issues` (`query=`) or `get_issue`, confirm it's the right one, then link it.

## Updating an existing issue

Pass `id` (e.g. `LIN-123`) to `save_issue` to update. Prefer the incremental fields:
`addLabels`/`removeLabels`, `removeBlockedBy`/`removeBlocks`/`removeRelatedTo`, and the `patch`
operations for surgical description edits rather than rewriting the whole body. Apply the same
restraint — don't expand a terse description into sections when editing.

## Checklist before creating

- [ ] Team resolved (and project resolved/confirmed, if interactive)
- [ ] Description is scope only — no invented steps, criteria, context, or follow-ups
- [ ] Related/blocking issues expressed as relations, not description links
- [ ] Only user-specified fields are set; no guessed assignee/priority/labels
