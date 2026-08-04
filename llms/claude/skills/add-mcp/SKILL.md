---
name: add-mcp
description: Add an MCP server to the current project. Use when the user wants to add, configure, or enable an MCP server like context7, kubernetes, playwright, storybook, or codegraphcontext.
argument-hint: <server-name | "list">
allowed-tools: Read, Glob, Grep, Edit, Write, Bash(devenv:*)
---

# Add MCP Server

Add an MCP server configuration to the current project.

## Instructions

### Step 1: Identify the server

If the argument is `list` or empty, read all files in the `servers/` directory next to this SKILL.md (use Glob on `~/.claude/skills/add-mcp/servers/*.md`) and list available presets with a one-line description of each.

Otherwise, match the argument to a preset server name. If a matching preset exists, read its file from `~/.claude/skills/add-mcp/servers/`. If no preset matches, ask the user for the server details (command, args, env, or URL).

### Step 2: Detect project setup

Check whether the project uses devenv by looking for a `devenv.nix` file in the project root.

### Step 3: Add the server

**If the project has `devenv.nix`:**

Add the server to `claude.code.mcpServers` in `devenv.nix`. Use the "devenv" snippet from the preset file. Make sure `claude.code.enable = true;` is present. If `config` is not already in the function arguments, add it.

Example structure in devenv.nix:
```nix
claude.code.mcpServers = {
  server-name = {
    type = "stdio";
    command = "npx";
    args = [ "-y" "package-name" ];
  };
};
```

After editing, tell the user to let direnv reload (or run `devenv shell`) so the `.mcp.json` is regenerated.

**If the project does NOT have `devenv.nix`:**

Add the server to `.mcp.json` in the project root. Create the file if it doesn't exist. Use the "mcp.json" snippet from the preset file.

The file structure is:
```json
{
  "mcpServers": {
    "server-name": {
      "command": "...",
      "args": ["..."]
    }
  }
}
```

Merge into existing `.mcp.json` if one exists — don't overwrite other servers.

### Step 4: Permissions

Check `.claude/settings.json` (project-level) for a permissions allow list. If one exists and uses granular MCP permissions, remind the user they may need to add `mcp__<server-name>` entries. If `enableAllProjectMcpServers` is set globally, this is not needed.

## Guidelines

- Never remove or modify existing MCP server entries unless the user asks
- Keep devenv.nix edits minimal — only touch `claude.code.mcpServers`
- If the preset needs a package (e.g., chromium for playwright), mention it but let the user decide whether to add it to devenv packages
