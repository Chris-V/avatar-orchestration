# Traefik

## Variables

```yaml
dest: <string>
timezone: <optional; string>
validate: <optional; bool>
traefik:
  config_dir: <string>
  default_network: <optional; string>
  domain: <optional; string>
  trusted_ips: <string[]>
  fragment: <optional; object>
    name: <string>
    definition: <object>
    proxy: <optional; object>
      entrypoint: <string>
      middlewares: <optional; string>
      network: <string>
      subdomain: <string>
```
