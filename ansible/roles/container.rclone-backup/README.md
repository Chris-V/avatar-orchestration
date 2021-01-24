# RClone Backup

## Variables

```yaml
dest: <string>
timezone: <optional; string>
validate: <optional; bool>
rclone_backup:
  config_dir: <string>
  allow_filters: <string[]>
  content_dir: <string>
  gce_auth: <object>
  gce_key: <optional; string>
  gce_bucket: <string>
  fragment: <optional; object>
    name: <string>
    definition: <object>
```
