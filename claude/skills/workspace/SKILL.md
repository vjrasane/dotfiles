---
name: workspace
description: Create a new jj workspace for isolated feature work. Use when the user wants to start work in a separate workspace, work on a feature in isolation, or set up a new jj workspace from a branch or bookmark.
argument-hint: [bookmark or change ID to start from] [feature name]
---

# Workspace

Create a new `jj` workspace rooted alongside the current repo.

## Instructions

1. **Determine the base**:
   - If the user provided a bookmark or change ID, use that
   - Otherwise determine the default branch: `jj config get revset-aliases.'trunk()'` and extract the bookmark name from the output
   - If the config lookup fails, fall back to `main`

2. **Determine the workspace name**:
   - If the user provided a feature name, slugify it: lowercase, dashes, no special chars
   - Otherwise suggest a name based on the task context or ask
   - Final directory: `ws-<feature-name>` (e.g. `ws-add-auth-middleware`)

3. **Resolve paths**:
   - Get the repo root: `jj workspace root`
   - The new workspace goes in the same parent directory: `$(dirname $(jj workspace root))/ws-<feature-name>`

4. **Create the workspace**:
   ```
   jj workspace add ../ws-<feature-name>
   ```

5. **Set the working copy to the base change**:
   ```
   cd ../ws-<feature-name>
   jj edit <base-change-or-bookmark>
   ```
   Then create a new empty change on top:
   ```
   jj new -m "<descriptive message>"
   ```

6. **Copy devenv and direnv files** from the source repo root to the new workspace:
   - Check for `.envrc`, `.devenv`, `.devenv.flake.nix`, and any other gitignored devenv-related files
   - Copy each one into the new workspace root:
     ```
     cp -a $(jj workspace root)/.envrc ../ws-<feature-name>/.envrc
     cp -a $(jj workspace root)/.devenv ../ws-<feature-name>/.devenv
     ```
   - Skip any that don't exist in the source repo

7. **Create a bookmark** on the new change using the same feature name:
   ```
   jj bookmark create <feature-name>
   ```

8. **Report**: Print the workspace path and current `jj log --limit 3` so the user can verify. Suggest the user `cd` into the workspace and start a new Claude session there.
