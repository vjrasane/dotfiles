---
name: start-ticket
description: Kick off work on a Linear ticket end to end — file or look up the ticket, create an isolated jj workspace for it, move into that workspace, pull the ticket, and brief its scope. Use when the user wants to start working on a subject or an existing ticket, "start a ticket", "kick off LIN-123", or spin up a workspace from a ticket and begin.
allowed-tools: Skill, AskUserQuestion, Bash, Read, Grep, Glob, mcp__plugin_hm_linear, mcp__claude_ai_Linear
argument-hint: <subject for a new ticket, or an existing ticket ID/URL; add "quick" to skip ticket questions>
---

# Start Ticket

Drive the opening of a ticket in one shot: ticket → workspace → move in → pull → brief.
Chain the existing `linear-ticket` and `workspace` skills rather than reimplementing them;
they stay the source of truth for how tickets and workspaces are made. Run unattended through
the brief, then hand back so the user directs the actual work.

Run from inside the repo the work belongs to — the workspace is a jj workspace of the current
repo.

## Input

The argument is either:

- **A subject** — free text describing new work (e.g. "rotate the ingestion S3 keys"). No
  ticket exists yet; create one.
- **An existing ticket** — a Linear identifier (`LIN-123`, `PROJ-45`) or a Linear URL
  (`https://linear.app/.../issue/LIN-123/...`). Skip creation; use it as-is.

Detect an existing ticket when the argument matches `^[A-Z][A-Z0-9]+-[0-9]+$` or is a
`linear.app` URL (extract the identifier from the URL path). Anything else is a subject.

## Workflow

1. **Resolve the ticket.**
   - *Existing:* fetch it with the Linear MCP (`get_issue`). Confirm it resolved; if not,
     stop and report.
   - *New:* invoke the `linear-ticket` skill with the subject. It runs interactive (confirms
     team/project) unless the argument contains "quick"/"small"/"fast" — pass those words
     through so its fast-path fires. When it returns, capture the created identifier.

2. **Create the workspace.** Invoke the `workspace` skill, telling it this is for the ticket
   and passing the ticket identifier and title so it builds the slugged directory
   (`ws-<ticket-id>-<name>`, lowercased). Let it pick the base (trunk) and do the jj setup,
   symlinks, and bookmark. Capture the workspace path it reports.

3. **Move in.** `cd` into the workspace path. The Bash working directory persists for the rest
   of the session, so all later work happens there — no new session is started. Verify with
   `jj workspace root` that the cwd is the new workspace before continuing.

4. **Pull the ticket.** Fetch the full issue (`get_issue`) — description, state, assignee,
   priority, labels, relations, and recent comments if present.

5. **Brief and hand back.** Summarize in a few lines: the identifier + title + URL, the scope
   (from the description), and anything load-bearing (relations, acceptance criteria the user
   put on the ticket). Do **not** start planning or writing code. End by handing control back
   to the user to direct the work.

## Reporting

One compact block at the end:

```
LIN-123 — Rotate ingestion S3 keys   <url>
Workspace: ../ws-lin-123-rotate-ingestion-s3-keys  (cwd now here)
Scope: <one or two lines from the ticket>
Ready — how do you want to start?
```

## Notes

- If the argument is empty, ask for the subject or ticket (`AskUserQuestion`), then proceed.
- If `linear-ticket` or `workspace` needs a decision (team, base), let that skill handle the
  asking — don't pre-empt it.
- Stop and report rather than guessing if the ticket won't resolve or the workspace creation
  fails; don't move in or brief on a half-built state.
