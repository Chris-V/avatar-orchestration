# Jellyfin

## Variables

```yaml
dest: <string>
timezone: <optional; string>
validate: <optional; bool>
jellyfin:
  config_dir: <string>
  movies_dir: <string>
  series_dir: <string>
  transcode_dir: <string>
  extra_groups: <optional>
    - gid: <number>
      name: <string>
  group: <optional; string>
    name: <string>
    definition: <object>
    proxy: <optional; object>
      entrypoint: <optional; string>
      middlewares: <optional; string>
      network: <optional; string>
      port: <optional; number>
      subdomain: <string>
```
