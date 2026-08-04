# playwright

Browser automation for testing and interaction via Playwright.

Runs headless by default. Needs a Chromium binary — on Nix, use `pkgs.chromium`.

## devenv

Add `chromium` to packages and reference it in the MCP config:

```nix
packages = with pkgs; [
  chromium
];

claude.code.mcpServers = {
  playwright = {
    type = "stdio";
    command = "npx";
    args = [
      "@playwright/mcp@latest"
      "--headless"
      "--executable-path"
      "${pkgs.chromium}/bin/chromium"
    ];
  };
};
```

## mcp.json

```json
"playwright": {
  "command": "npx",
  "args": [
    "@playwright/mcp@latest",
    "--headless"
  ]
}
```

Outside Nix, the system Chromium is used automatically. Pass `--executable-path` only if you need a specific binary.
