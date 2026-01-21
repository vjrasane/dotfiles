{
  dotfiles,
  ...
}:
{
  home.file."CLAUDE.md".source = "${dotfiles}/CLAUDE.md";
  home.file.".claude/settings.json".source = "${dotfiles}/.claude/settings.json";
  home.file.".mcp.json".source = "${dotfiles}/.mcp.json";
}
