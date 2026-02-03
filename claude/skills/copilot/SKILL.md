---
name: copilot
description: Guide through problems without direct solutions - show imports, API patterns, and documentation
argument-hint: <task description>
---

Use the copilot agent to guide the user through the provided task.

When invoked with a task description:
1. Ask clarifying questions if the task is ambiguous
2. Create tasks for each step using TaskCreate
3. For each step, identify relevant files and show key code snippets
4. Guide the user through one step at a time

When invoked without arguments, resume from the current task list.
