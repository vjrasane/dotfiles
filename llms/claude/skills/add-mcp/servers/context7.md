# context7

Library and API documentation lookup via Context7.

Requires `CONTEXT7_API_KEY` environment variable.

## devenv

```nix
context7 = {
  type = "stdio";
  command = "npx";
  args = [ "-y" "@upstash/context7-mcp" ];
  env = {
    CONTEXT7_API_KEY = "\${CONTEXT7_API_KEY}";
  };
};
```

Note: use `dotenv.enable = true;` in devenv.nix and put the API key in `.env`.

## mcp.json

```json
"context7": {
  "command": "npx",
  "args": ["-y", "@upstash/context7-mcp"],
  "env": {
    "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
  }
}
```
