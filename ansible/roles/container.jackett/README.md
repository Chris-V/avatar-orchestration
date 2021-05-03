# Jackett

## Variables

```yaml
dest: <string>
timezone: <optional; string>
validate: <optional; bool>
deluge:
  config_dir: <string>
  downloads_dir: <string>
  extra_groups: <optional>
    - gid: <number>
      name: <string>
  group: <optional; string>
  fragment: <optional; object>
    name: <string>
    definition: <object>
    proxy: <optional; object>
      entrypoint: <optional; string>
      middlewares: <optional; string>
      network: <optional; string>
      port: <optional; number>
      subdomain: <string>
```
