# go-my-mcp Docker

Build and run [go-my-mcp](https://github.com/J-Siu/go-my-mcp) with Docker Compose:

```yaml
services:
  go-my-mcp:
    build:
      context: .
      args:
        VERSION: v1.0.3
    command: ["start"]
    environment:
      GO_MY_MCP_SEARXNGURL: ${SEARXNG_URL:?Set SEARXNG_URL to a reachable SearXNG URL}
      GO_MY_MCP_APIKEY: ${GO_MY_MCP_APIKEY:-}
    ports:
      - "127.0.0.1:9000:9000"
    restart: unless-stopped
```

Save this as `compose.yaml` in the same directory as the Dockerfile. Set the
SearXNG URL and, optionally, an API key in a `.env` file:

```dotenv
SEARXNG_URL=http://searxng.example.com
GO_MY_MCP_APIKEY=replace-with-a-secret
```

Keep `.env` out of version control. The API key is optional; when set, clients
must send it with every request. The port is bound to localhost; adjust the
host address if clients on other machines need to connect.

Start the container and access the MCP endpoint at `http://localhost:9000/mcp`:

```sh
docker compose up --build -d
```

The image build defaults to release `v1.0.3`; update the `VERSION` build
argument to compile a different go-my-mcp tag.