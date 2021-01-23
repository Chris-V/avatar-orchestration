# Mosquitto

## Variables

```yaml
dest: <string>
timezone: <optional; string>
validate: <optional; bool>
mosquitto:
  config_dir: <string>
  group: <optional; string>
  users:
    - name: <string>
      hashed_password: <string>
      acl:
        - topic: <string>
          permission: <read|write|readwrite>
  fragment: <optional; object>
    name: <string>
    definition: <object>
```
