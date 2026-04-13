# storybook

Connect to a running Storybook dev server's MCP endpoint.

Storybook must be running (default port 6006). Requires the `@storybook/experimental-addon-mcp` addon — install it and add to `.storybook/main.ts`:

```ts
addons: [
  '@storybook/experimental-addon-mcp',
],
```

## devenv

```nix
storybook = {
  type = "http";
  url = "http://localhost:6006/mcp";
};
```

Adjust the port if your Storybook runs elsewhere.

## mcp.json

```json
"storybook": {
  "type": "http",
  "url": "http://localhost:6006/mcp"
}
```
