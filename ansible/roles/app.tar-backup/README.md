# TAR Backup

## Variables

```yaml
dest: <string>
timezone: <optional; string>
validate: <optional; bool>
tar_backup:
  backup_dir: <string>
  config_dir: <string>
  data_dir: <string>
  crontab: <string>
  exclusions: <optional; string[]>
  pause_containers: <optional; string[]>
  fragment: <optional; object>
      name: <string>
      definition: <object>
```
