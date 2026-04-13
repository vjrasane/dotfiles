# kubernetes

Kubernetes cluster operations: list pods, get resources, read logs, inspect events.

Uses the current kubeconfig context.

## devenv

```nix
kubernetes = {
  type = "stdio";
  command = "npx";
  args = [ "-y" "kubernetes-mcp-server@latest" ];
};
```

## mcp.json

```json
"kubernetes": {
  "command": "npx",
  "args": ["-y", "kubernetes-mcp-server@latest"]
}
```
