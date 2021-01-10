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
    - name: <string>
  group: <optional; string>
  fragment: <optional; object>
      name: <string>
      definition: <object>
```
