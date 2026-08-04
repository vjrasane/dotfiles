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
    fetchurl
    unzip
    makeWrapper
    buildNpmPackage
    stdenvNoCC
    ;

  context = builtins.readFile "${dotfiles}/llms/claude/context.md";

  kimiCode =
    let
      version = "0.32.0";
      base = "https://github.com/MoonshotAI/kimi-code/releases/download/%40moonshot-ai/kimi-code%40${version}";
      sources = {
        "x86_64-linux" = {
          file = "kimi-code-linux-x64.zip";
          hash = "sha256-C4fO8HOuYTCCo3q0tJzNENEDsruyJ0/69FjIvWgb4rA=";
        };
        "aarch64-linux" = {
          file = "kimi-code-linux-arm64.zip";
          hash = "sha256-L9WtrtIH80frHCnrtcu/GNx1ZKN3rvnGYoLZ8Hv8C48=";
        };
        "x86_64-darwin" = {
          file = "kimi-code-darwin-x64.zip";
          hash = "sha256-OFsG6gdKoEhP0KYV3G+SCdGutohiVeZOyN2t9CvVQAA=";
        };
        "aarch64-darwin" = {
          file = "kimi-code-darwin-arm64.zip";
          hash = "sha256-Kw5+ufdIzIj4SqGBDnZ55b/sfWn3DukaM2yGDo7PnZU=";
        };
      };
      inherit (stdenvNoCC.hostPlatform) system;
      src' = sources.${system} or (throw "kimi-code: unsupported system ${system}");
    in
    stdenvNoCC.mkDerivation {
      pname = "kimi-code";
      inherit version;

      src = fetchurl {
        url = "${base}/${src'.file}";
        inherit (src') hash;
      };

      nativeBuildInputs = [ unzip ];

      # Prebuilt bun single-file executable: patchelf/strip corrupt the JS payload
      # appended after the ELF, so install it verbatim and rely on the host loader.
      dontStrip = true;
      dontPatchELF = true;

      unpackPhase = ''
        runHook preUnpack
        unzip -q $src
        runHook postUnpack
      '';

      installPhase = ''
        runHook preInstall
        install -Dm755 kimi $out/bin/kimi
        runHook postInstall
      '';

      meta = {
        description = "Kimi Code CLI — Moonshot AI terminal coding agent";
        mainProgram = "kimi";
        homepage = "https://github.com/MoonshotAI/kimi-code";
        license = lib.licenses.mit;
        platforms = builtins.attrNames sources;
        maintainers = [ ];
      };
    };

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
  home.packages = [ kimiCode ];

  home.file.".kimi-code/AGENTS.md".text = context;

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
      settings = {
        model = "anthropic/claude-opus-4-8";
        small_model = "anthropic/claude-haiku-4-5";
        plugin = [
          "superpowers@git+https://github.com/obra/superpowers.git"
          "opencode-claude-auth"
        ];
        permission = {
          bash = {
            "*" = "ask";
            "ssh *" = "ask";
            "echo *" = "allow";
            "head *" = "allow";
            "go vet *" = "allow";
            "go build *" = "allow";
          };
        };
        lsp = true;
      };
    };

    claude-code = {
      inherit context;
      enable = true;
      package = pkgs.claude-code;
      agents = {
        code-reviewer = "${dotfiles}/llms/claude/agents/code-reviewer.md";
        cooklang = "${dotfiles}/llms/claude/agents/cooklang.md";
        copilot = "${dotfiles}/llms/claude/agents/copilot.md";
        proofreader = "${dotfiles}/llms/claude/agents/proofreader.md";
      };
      skills = {
        add-mcp = "${dotfiles}/llms/claude/skills/add-mcp";
        copilot = "${dotfiles}/llms/claude/skills/copilot";
        planner = "${dotfiles}/llms/claude/skills/planner";
        repo-init = "${dotfiles}/llms/claude/skills/repo-init";
        researcher = "${dotfiles}/llms/claude/skills/researcher";
        review = "${dotfiles}/llms/claude/skills/review";
        skill-writer = "${dotfiles}/llms/claude/skills/skill-writer";
        workspace = "${dotfiles}/llms/claude/skills/workspace";
        writing-assistant = "${dotfiles}/llms/claude/skills/writing-assistant";
      };

      enableMcpIntegration = true;
      settings = {
        model = "claude-opus-4-8";
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
        effortLevel = "medium";
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
          "Bash(jj workspace *)"
          "Bash(jj new *)"
          "Bash(jj edit *)"
          "Bash(jj bookmark *)"
          "Bash(gh api:*)"
          "Bash(gh search:*)"
          "Bash(nix eval*)"
          "Bash(nix build*)"
          "Bash(nix search:*)"
          "Bash(nix why-depends*)"
          "Bash(nix path-info*)"

          "mcp__context7"
          "mcp__sequential-thinking"

          "Read(~/.claude/skills/*)"
          "Read(~/dotfiles/llms/claude/skills/*)"
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
                  command = "{ printf '\\a' > /dev/tty; } 2>/dev/null || true";

                }
              ];
            }
          ];
        };
      };
    };
  };
}
