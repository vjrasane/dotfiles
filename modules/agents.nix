{
  dotfiles,
  ...
}:
{
  home.file."CLAUDE.md".source = "${dotfiles}/CLAUDE.md";
  home.file.".claude/settings.json".source = "${dotfiles}/claude/settings.json";
  home.file.".claude/agents".source = "${dotfiles}/claude/agents";
  home.file.".claude/skills".source = "${dotfiles}/claude/skills";
}
