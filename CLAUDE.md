- This repo manages dotfiles using home manager. do not modify existing config files directly
- This repo uses devenv to manage the development environment. use this to install and conigure tools during development

## Preferences
- Keep changes minimal and focused
- Refrain from adding unnecessary comments. Write self documenting code. Only explain patterns that deviate from best practices.
- Prefer editing existing files over creating new ones
- Follow existing code patterns and conventions

## Toolbox (~/.claude/toolbox/)

A directory of reusable scripts that you can invoke, compose, and extend. It is on PATH.

### Discovery
- Run `_index` to list available toolbox scripts with descriptions
- Run `_tools` to list installed CLI tools (home-manager + active devenv)

### Before writing a new script
1. Run `_index` — check if an existing script already does what you need
2. If composable, pipe or call existing scripts rather than rewriting logic
3. Run `_tools` to check what CLI tools are available

### Writing new scripts
- Write to `~/.claude/toolbox/` with a descriptive filename (a hook auto-sets +x, no need to chmod)
- Pick the right language: bash for glue/CLI composition, python for data processing, node for API work
- Always include the metadata header:
  ```
  # @desc: What this script does
  # @usage: script-name <required> [optional]
  # @deps: comma-separated list of required tools
  ```
- Python scripts: use `#!/usr/bin/env -S uv run --script` with PEP 723 inline dependencies
- Node scripts: use `#!/usr/bin/env bun` — bun does not support inline deps, so only use built-in APIs (fetch, fs, etc.) or prefer python for scripts that need packages
- Bash scripts: use `#!/usr/bin/env bash` with `set -euo pipefail`

### When a tool is missing
- If the tool is only needed for the current project → suggest adding to `devenv.nix`
- If the tool should be globally available → suggest adding to `home.nix`
- Or sidestep: use a python/node script with inline deps instead
- Always ask before modifying `devenv.nix` or `home.nix`

## MCP Usage
- **context7**: Use for library/API documentation, code generation, setup or configuration steps without me having to explicitly ask
- **kubernetes**: Use for any k8s cluster operations, troubleshooting, or resource inspection
- **filesystem**: Use when needing to read/write files outside the current working directory
- **sequential-thinking**: Use for complex architectural decisions, multi-step problem solving, or system design tasks
- **codegraphcontext**: Use for code structure analysis, dependency graphs, and understanding relationships between modules
