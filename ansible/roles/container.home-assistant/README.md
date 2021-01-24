# Home-Assistant

## Variables

```yaml
dest: <string>
timezone: <optional; string>
validate: <optional; bool>
home_assistant:
  config_dir: <string>
  config_secrets_files: <string[]>
  config_secrets_src_path: <string>
  force_ssh_key: <optional; boolean>
  repo:
    name: <string>
    organisation: <string>
    personal_access_token: <string>
  fragment: <optional; object>
    name: <string>
    definition: <object>
```
