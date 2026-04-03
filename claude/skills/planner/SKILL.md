---
name: planner
description: Create or refine an implementation plan for a feature or task. Use when the user asks to plan, design an approach, outline steps, or break down a task into an implementation plan. Reads research.md for context and produces a plan.md file.
allowed-tools: Read, Grep, Glob, Write, Edit, Agent, TaskCreate, TaskUpdate, TaskList, TaskGet, AskUserQuestion
argument-hint: <feature or task to plan>
---

# Planner

Create focused, actionable implementation plans from a feature description or existing research.

## Instructions

1. **Gather context**:
   - Read the user's input to understand what needs to be planned
   - Check for `research.md` in the current directory — if it exists, use it as background context
   - Check for `plan.md` in the current directory — if it exists, this is a refinement pass

2. **If no plan.md exists** (new plan):
   - Identify what the end result should look like
   - Ask clarifying questions when the scope, constraints, or requirements are ambiguous — do not guess
   - Once clear, proceed to writing the plan

3. **If plan.md already exists** (refinement):
   - Read the full plan.md
   - Look for inline comments (lines starting with `>` or `<!-- ... -->`) left by the user
   - Address each comment: update, expand, or rework the relevant section
   - If the user's request asks for specific changes, apply those
   - Preserve completed task checkmarks

4. **Explore the codebase** before writing:
   - Identify files, modules, and patterns relevant to the plan
   - Note existing conventions, dependencies, and constraints
   - Use Agent with subagent_type=Explore for broader searches when needed

5. **Write plan.md** with this structure:

```markdown
# Plan: <Title>

## Goal
One-paragraph description of the desired outcome.

## Context
Key constraints, dependencies, and relevant existing code or patterns.

## Approach
High-level strategy in 2-4 sentences.

## Tasks

- [ ] 1. <Task title>
  - What: <what to do>
  - Where: <files/modules involved>
  - Notes: <edge cases, dependencies on other tasks>

- [ ] 2. <Task title>
  - What: <what to do>
  - Where: <files/modules involved>
  - Notes: <edge cases, dependencies on other tasks>

...

## Open Questions
- Anything unresolved that needs user input before implementation
```

6. **Present the plan**: Give a brief summary and call out any open questions that need resolution before starting.

## Guidelines

- Keep tasks small and independently verifiable
- Order tasks by dependency — earlier tasks should not depend on later ones
- Reference specific files and code paths, not vague module names
- Each task should be completable in a single focused session
- Do not include testing or documentation tasks unless they are explicitly part of the request
- When refining, show what changed so the user can review the delta
