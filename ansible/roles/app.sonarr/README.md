# Sonarr

## Variables

```yaml
dest: <string>
timezone: <optional; string>
validate: <optional; bool>
sonarr:
  config_dir: <string>
  downloads_dir: <string>
  series_dir: <string>
  extra_groups: <optional>
    - gid: <number>
    - name: <string>
  group: <optional; string>
  series_group: <optional; string>
  fragment: <optional; object>
      name: <string>
      definition: <object>
```
