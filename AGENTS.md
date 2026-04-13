- This repo manages dotfiles using home manager. do not modify existing config files directly

## Preferences
- Keep changes minimal and focused
- Refrain from adding unnecessary comments. Write self documenting code. Only explain patterns that deviate from best practices.
- Prefer editing existing files over creating new ones
- Follow existing code patterns and conventions

## Development Environment

This project uses **devenv** to manage development tools and dependencies. The environment activates automatically via direnv when you enter the project directory.

- Install CLI tools and system-level dependencies via `devenv.nix` (under `packages`)
- Do NOT use devenv for language-specific libraries — use the project's native package manager instead (npm, uv, pip, cargo, go modules, etc.)
- To add a new tool: edit `devenv.nix`, then let direnv reload or run `devenv shell`

## Version Control

This project uses **jj (Jujutsu)** for version control with git colocated mode. NEVER use git commands unless absolutely necessary (e.g., a tool has no jj support, or jj lacks the needed functionality). If you must use git, explain why.

jj quick reference:
- `jj new` — start new work on top of current change
- `jj describe -m "message"` — describe the current change
- `jj commit -m "message"` — snapshot working copy and start a new change
- `jj log` — view change history
- `jj diff` — view uncommitted changes
- `jj bookmark create <name>` — create a bookmark (branch equivalent)
- `jj git fetch` — fetch from remote
- `jj git push` — push to remote

Do NOT use `git add`, `git commit`, `git push`, `git pull`, `git checkout`, `git switch`, `git branch`, or any other git porcelain command.

## Agent Configuration

Agents and skills are defined in `claude/agents/` and `claude/skills/` in this repo. Home Manager symlinks them to `~/.claude/agents/` and `~/.claude/skills/` via `modules/agents.nix`. Edit the source files here, not the symlinked copies.

MCP servers are configured in `modules/agents.nix` via `programs.mcp.servers` (shared, agent-agnostic) and wired into Claude Code with `programs.claude-code.enableMcpIntegration`.

## MCP Usage
- **context7**: Use for library/API documentation, code generation, setup or configuration steps without me having to explicitly ask
- **kubernetes**: Use for any k8s cluster operations, troubleshooting, or resource inspection
- **filesystem**: Use when needing to read/write files outside the current working directory
- **sequential-thinking**: Use for complex architectural decisions, multi-step problem solving, or system design tasks
- **codegraphcontext**: Use for code structure analysis, dependency graphs, and understanding relationships between modules
