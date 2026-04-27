{
  pkgs,
  lib,
  dotfiles,
  ...
}:
let
  inherit (pkgs)
    nodejs
    fetchFromGitHub
    makeWrapper
    buildNpmPackage
    ;

  context = builtins.readFile "${dotfiles}/claude/context.md";

  claudeHud = buildNpmPackage (finalAttrs: {
    pname = "claude-hud";
    version = "0.0.12";

    src = fetchFromGitHub {
      owner = "jarrodwatts";
      repo = "claude-hud";
      rev = "v${finalAttrs.version}";
      hash = "sha256-qrF1kz7EPt1g5F4y51nrDjmyoZlxt8hcfjoejCLCiQA=";
    };

    npmDepsHash = "sha256-nPbduKkAgeDmz8t11nSeCXNnub2R0LJfZN+dGZxMNaw=";

    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/{lib,bin}
      cp -r dist $out/lib/
      makeWrapper ${lib.getExe nodejs} $out/bin/claude-hud \
        --add-flags "$out/lib/dist/index.js"
      runHook postInstall
    '';

    meta = {
      description = "Real-time statusline HUD for Claude Code";
      mainProgram = "claude-hud";
      homepage = "https://github.com/jarrodwatts/claude-hud";
      license = lib.licenses.mit;
      maintainers = [ ];
    };
  });
in
{
  programs = {
    mcp = {
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

    opencode = {
      inherit context;
      enable = true;
      enableMcpIntegration = true;
      settings.plugin = [ "superpowers@git+https://github.com/obra/superpowers.git" ];
    };

    claude-code = {
      inherit context;
      enable = true;
      package = pkgs.claude-code;
      agents = {
        code-reviewer = "${dotfiles}/claude/agents/code-reviewer.md";
        cooklang = "${dotfiles}/claude/agents/cooklang.md";
        copilot = "${dotfiles}/claude/agents/copilot.md";
        proofreader = "${dotfiles}/claude/agents/proofreader.md";
      };
      skills = {
        add-mcp = "${dotfiles}/claude/skills/add-mcp";
        copilot = "${dotfiles}/claude/skills/copilot";
        planner = "${dotfiles}/claude/skills/planner";
        repo-init = "${dotfiles}/claude/skills/repo-init";
        researcer = "${dotfiles}/claude/skills/researcer";
        review = "${dotfiles}/claude/skills/review";
        skill-writer = "${dotfiles}/claude/skills/skill-writer";
        writing-assistant = "${dotfiles}/claude/skills/writing-assistant";
      };

      enableMcpIntegration = true;
      settings = {
        model = "claude-opus-4-6";
        fastMode = false;
        alwaysThinkingEnabled = true;
        autoCompactWindow = 700000;
        enableAllProjectMcpServers = true;
        enabledPlugins = {
          "lua-lsp@claude-plugins-official" = true;
          "superpowers@claude-plugins-official" = true;
          "gopls-lsp@claude-plugins-official" = true;
          "typescript-lsp@claude-plugins-official" = true;
          "rust-analyzer-lsp@claude-plugins-official" = true;
          "pyright-lsp@claude-plugins-official" = true;
        };
        attribution = {
          commit = "";
          pr = "";
        };
        effortLevel = "high";
        includeGitInstructions = false;
        disableDeepLinkRegistration = "disable";
        statusLine = {
          type = "command";
          command = "${claudeHud}";
        };
        permissions.allow = [
          "WebSearch"

          "WebFetch(domain:github.com)"
          "WebFetch(domain:api.github.com)"
          "WebFetch(domain:raw.githubusercontent.com)"
          "WebFetch(domain:*.github.io)"
          "WebFetch(domain:docs.gitlab.com)"

          "WebFetch(domain:search.nixos.org)"
          "WebFetch(domain:nixos.org)"
          "WebFetch(domain:nixos.wiki)"
          "WebFetch(domain:home-manager-options.extranix.com)"

          "WebFetch(domain:crates.io)"
          "WebFetch(domain:kubernetes.io)"

          "Bash(find *)"
          "Bash(printf *)"
          "Bash(grep *)"
          "Bash(rg *)"
          "Bash(cat *)"
          "Bash(cargo search:*)"
          "Bash(helm show values:*)"
          "Bash(jj describe*)"
          "Bash(jj log*)"
          "Bash(jj diff*)"
          "Bash(jj show*)"
          "Bash(gh api:*)"
          "Bash(gh search:*)"
          "Bash(nix eval*)"
          "Bash(nix build*)"
          "Bash(nix search:*)"
          "Bash(nix why-depends*)"
          "Bash(nix path-info*)"

          "mcp__context7"
          "mcp__sequential-thinking"
        ];
        hooks = {
          Notification = [
            {
              matcher = "permission_prompt";
              hooks = [
                {
                  type = "command";
                  command = "printf '\\a' > /dev/tty";
                }
              ];
            }
          ];
          Stop = [
            {
              matcher = "";
              hooks = [
                {
                  type = "command";
                  command = "printf '\\a' > /dev/tty";
                }
              ];
            }
          ];
        };
      };
    };
  };
}
