{
  pkgs,
  dotfiles,
  ...
}:
{
  home.file."AGENTS.md".source = "${dotfiles}/AGENTS.md";

  programs.mcp = {
    enable = true;
    servers = {
      context7 = {
        command = "npx";
        args = [
          "-y"
          "@upstash/context7-mcp"
        ];
        env.CONTEXT7_API_KEY = "\${CONTEXT7_API_KEY}";
      };
      sequential-thinking = {
        command = "npx";
        args = [
          "-y"
          "@modelcontextprotocol/server-sequential-thinking"
        ];
      };
    };
  };

  programs.claude-code = {
    enable = true;
    package = pkgs.claude-code;
    enableMcpIntegration = true;
    settings = {
      enabledPlugins = {
        "lua-lsp@claude-plugins-official" = true;
        "gopls-lsp@claude-plugins-official" = true;
        "typescript-lsp@claude-plugins-official" = true;
      };
      permissions.allow = [
        "WebSearch"
        "WebFetch(domain:github.com)"
        "WebFetch(domain:raw.githubusercontent.com)"
        "WebFetch(domain:docs.gitlab.com)"
        "WebFetch(domain:kubernetes.io)"
        "WebFetch(domain:nixos.org)"
        "WebFetch(domain:nixos.wiki)"
        "WebFetch(domain:home-manager-options.extranix.com)"
        "mcp__context7"
        "mcp__sequential-thinking"
        "Bash(helm show values:*)"
        "Bash(grep:*)"
      ];
      enableAllProjectMcpServers = true;
      hooks.PostToolUse = [
        {
          matcher = "Write";
          hooks = [
            {
              type = "command";
              command = ''jq -r '.tool_input.file_path // empty' | { read -r f; [[ "$f" == "$HOME/.claude/toolbox/"* ]] && chmod +x "$f"; } 2>/dev/null || true'';
            }
          ];
        }
      ];
    };
    agentsDir = "${dotfiles}/claude/agents";
    skillsDir = "${dotfiles}/claude/skills";
  };
}
