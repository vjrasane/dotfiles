# codegraphcontext

Code structure analysis, dependency graphs, and module relationship mapping.

Requires `uvx` (from uv). On NixOS/nix, `LD_LIBRARY_PATH` may need to point to gcc's lib directory.

## devenv

```nix
codegraphcontext = {
  type = "stdio";
  command = "uvx";
  args = [ "--from" "codegraphcontext" "cgc" "mcp" "start" ];
};
```

If you get linker errors on NixOS, add to devenv.nix:

```nix
packages = with pkgs; [ gcc ];
```

And set `LD_LIBRARY_PATH`:

```nix
codegraphcontext = {
  type = "stdio";
  command = "uvx";
  args = [ "--from" "codegraphcontext" "cgc" "mcp" "start" ];
  env = {
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };
};
```

## mcp.json

```json
"codegraphcontext": {
  "command": "uvx",
  "args": ["--from", "codegraphcontext", "cgc", "mcp", "start"]
}
```
