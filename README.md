# Hermes Workspace (WebUI) Docker Image

Lightweight container for the Hermes agent WebUI.

## Usage

Add to your `docker-compose.yml`:

```yaml
services:
  hermes:
    image: ghcr.io/kingsclaws/hermes-docker:latest
    container_name: hermes
    # ... your existing config ...

  hermes-ui:
    image: ghcr.io/kingsclaws/hermes-ui:latest
    container_name: hermes-ui
    restart: unless-stopped
    ports:
      - "3002:3002"
    environment:
      - HERMES_API_URL=http://hermes:3000
    depends_on:
      - hermes
```

Then visit `http://localhost:3002`.
