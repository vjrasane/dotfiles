{
  # keyd runs as a system daemon (apt install, bootstrap with `just setup-keyd`)
  # since home-manager can't own system services. This is the canonical config;
  # /etc/keyd/default.conf symlinks here. Apply: home-manager switch, then
  # `sudo keyd.rvaiya reload` (Ubuntu renames the CLI; see README.Debian).
  xdg.configFile."keyd/default.conf".text = ''
    # Homerow mods: tap = letter, hold = modifier.
    # Left:  A=Super S=Alt  D=Shift F=Ctrl
    # Right: ;=Super L=Alt  K=Shift J=Ctrl  (mirrored)

    [ids]
    *

    [main]
    capslock = overload(control, esc)
    space = overloadt(nav, space, 250)

    a = overloadt(meta, a, 225)
    s = overloadt(alt, s, 250)
    d = overloadt(shift, d, 250)
    f = overloadt(control, f, 175)

    j = overloadt(control, j, 175)
    k = overloadt(shift, k, 250)
    l = overloadt(alt, l, 250)
    ; = overloadt(meta, ;, 225)

    # Real Caps Lock: hold Shift (D/K or a Shift key) and tap Caps Lock.
    [shift]
    capslock = capslock

    # Hold Space longer than 250ms: hjkl become arrows.
    # Note: a space held in isolation that long emits no character.
    [nav]
    h = left
    j = down
    k = up
    l = right
  '';
}
