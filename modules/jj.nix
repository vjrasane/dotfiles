{
  config,
  pkgs,
  dotfiles,
  lib,
  ...
}:
let
  keys = import "${dotfiles}/keys.nix";

  git_user = config.programs.git.settings.user;
in
{
  home.packages = [ pkgs.jjui ];

  programs.jujutsu = {
    enable = true;
    settings = {
      user = git_user;

      ui = {
        default-command = [
          "log"
          "--reversed"
          "--no-pager"
        ];
        pager = "delta";
        editor = "nvim";
        show-cryptographic-signatures = true;
        diff-editor = ":builtin";
        diff-formatter = [
          "${pkgs.difftastic}/bin/difft"
          "--color=always"
          "$left"
          "$right"
        ];
        merge-editor = "vimdiff";
      };

      git = {
        collocate = true;
        sign-on-push = true;
        write-change-id-header = true;
        subprocess = true;
        private-commits = "description(glob:'wip:*') | description(glob:'private:*') | description(glob:'drop:*') | description(glob:'*DO NOT COMMIT*')";
      };

      signing = {
        behavior = "drop";
        backend = "ssh";
        key = keys.currentMachine.privateKeyPath config.home.homeDirectory;
        backends.ssh.allowed-signers = "${config.xdg.configHome}/git/allowed_signers";
      };

      merge.hunk-level = "word";
      merge-tools.vimdiff.program = pkgs.neovim.meta.mainProgram;
      # merge-tools.nvim = {
      #   program = "nvim";
      #   merge-args = [
      #     "-d"
      #     "$left"
      #     "$base"
      #     "$right"
      #     "-c"
      #     "wincmd J | wincmd ="
      #   ];
      # };

      remotes = {
        origin.auto-track-bookmarks = "glob:*";
        upstream.auto-track-bookmarks = ''exact:"main" | exact:"master"'';
      };

      aliases = {
        ui = [
          "util"
          "exec"
          "--"
          "jjui"
        ];
        bc = [
          "bookmark"
          "create"
        ];
        bm = [
          "bookmark"
          "move"
        ];
        bmm = [
          "bookmark"
          "move"
          "main"
        ];
        d = [ "describe" ];
        c = [ "commit" ];
        de = [ "diffedit" ];
        e = [ "edit" ];
        gf = [
          "git"
          "fetch"
        ];
        gp = [
          "util"
          "exec"
          "--"
          "jj-push"
        ];
        i = [
          "git"
          "init"
          "--colocate"
        ];
        l = [
          "log"
          "-r"
          "(trunk()..@):: | (trunk()..@)-"
        ];
        ll = [
          "log"
          "-r"
          "all()"
        ];
        tug = [
          "bookmark"
          "move"
          "--from"
          "closest_bookmark(@)"
          "--to"
          "closest_pushable(@)"
        ];
        ab = [ "abandon" ];
        append = [
          "new"
          "-A"
          "@"
        ];
        prepend = [
          "new"
          "-B"
          "@"
        ];
        ap = [ "append" ];
        pre = [ "prepend" ];
      };

      revset-aliases = {
        "closest_bookmark(to)" = "heads(::to & bookmarks())";
        "closest_pushable(to)" =
          ''heads(::to & mutable() & ~description(exact:"") & (~empty() | merges()))'';
      };
    };
  };
}
