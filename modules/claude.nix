{
  pkgs,
  dotfiles,
  homeDir,
  ...
}:
let
  ldLibraryPath = "${pkgs.stdenv.cc.cc.lib}/lib";
in
{
  home.file."CLAUDE.md".source = "${dotfiles}/CLAUDE.md";

  home.file.".claude/settings.json".text = builtins.toJSON {
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
      "mcp__codegraphcontext"
      "mcp__kubernetes__resources_get"
      "mcp__kubernetes__pods_list_in_namespace"
      "mcp__kubernetes__resources_list"
      "mcp__kubernetes__events_list"
      "mcp__kubernetes__pods_log"
      "mcp__kubernetes__pods_list"
      "mcp__kubernetes__pods_get"
      "mcp__filesystem__search_files"
      "mcp__filesystem__directory_tree"
      "mcp__filesystem__read_text_file"
      "mcp__filesystem__list_directory"
      "Bash(helm show values:*)"
      "Bash(grep:*)"
    ];
    enableAllProjectMcpServers = true;
  };

  home.file.".mcp.json".text = builtins.toJSON {
    mcpServers = {
      context7 = {
        command = "npx";
        args = [
          "-y"
          "@upstash/context7-mcp"
        ];
        env.CONTEXT7_API_KEY = "\${CONTEXT7_API_KEY}";
      };
      kubernetes = {
        command = "npx";
        args = [
          "-y"
          "kubernetes-mcp-server@latest"
        ];
      };
      filesystem = {
        command = "npx";
        args = [
          "-y"
          "@modelcontextprotocol/server-filesystem"
          homeDir
        ];
      };
      sequential-thinking = {
        command = "npx";
        args = [
          "-y"
          "@modelcontextprotocol/server-sequential-thinking"
        ];
      };
      codegraphcontext = {
        command = "uvx";
        args = [
          "--from"
          "codegraphcontext"
          "cgc"
          "mcp"
          "start"
        ];
        env.LD_LIBRARY_PATH = ldLibraryPath;
      };
      n8n = {
        command = "npx";
        args = [ "n8n-mcp" ];
        env = {
          MCP_MODE = "stdio";
          N8N_MCP_TELEMETRY_DISABLED = "true";
        };
      };
    };
  };

  home.file.".claude/agents".source = "${dotfiles}/claude/agents";
  home.file.".claude/skills".source = "${dotfiles}/claude/skills";
}
