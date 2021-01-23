# Plant-Gateway

## Variables

```yaml
dest: <string>
timezone: <optional; string>
validate: <optional; bool>
plantgateway:
  config_dir: <string>
  mqtt:
    server: <string>
    port: <number>
    client_id: <string>
    user: <string>
    password: <string>
  sensors:
    - mac: <string>
      name: <string>
  fragment: <optional; object>
      name: <string>
      definition: <object>
```
