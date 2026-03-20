# Temporal Server with PostgreSQL Backend

A Docker Compose setup for running [Temporal](https://temporal.io/) server with PostgreSQL as the persistence backend.

## Services

| Service | Description | Port |
|---------|-------------|------|
| `temporal` | Temporal server (gRPC API) | 7233 |
| `temporal-ui` | Temporal Web UI | 8080 |
| `temporal-admin-tools` | CLI tools for administration | - |
| `postgresql-temporal` | PostgreSQL database | internal only |

## Prerequisites

- Docker Engine 20.10+
- Docker Compose v2.0+

## Quick Start

1. **Start all services:**

   ```bash
   docker compose up -d
   ```

2. **Access the Temporal Web UI:**

   Open [http://localhost:8080](http://localhost:8080) in your browser.

3. **Connect your application:**

   Configure your Temporal client to connect to `localhost:7233`.

## Usage

### Start services

```bash
docker compose up -d
```

### View logs

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f temporal
```

### Stop services

```bash
docker compose down
```

### Stop and remove data

```bash
docker compose down -v
```

### Using Admin Tools

Access the Temporal CLI (tctl) via the admin-tools container:

```bash
docker compose exec temporal-admin-tools bash

# Inside the container:
tctl namespace list
tctl workflow list
```

Or run commands directly:

```bash
docker compose exec temporal-admin-tools tctl namespace list
```

### Create a namespace

```bash
docker compose exec temporal-admin-tools tctl --namespace my-namespace namespace register
```

## Configuration

### Environment Variables

Configuration is centralized using a YAML anchor (`x-postgres-config`) for PostgreSQL settings. The Temporal service connects using a `DATABASE_URL` constructed from these values.

You can override the defaults by setting environment variables before running docker compose:

```bash
export POSTGRES_USER=myuser
export POSTGRES_PASSWORD=mypassword
export POSTGRES_DB=mydb
docker compose up -d
```

| Variable | Default | Description |
|----------|---------|-------------|
| `POSTGRES_USER` | `temporal` | PostgreSQL username |
| `POSTGRES_PASSWORD` | `temporal` | PostgreSQL password |
| `POSTGRES_DB` | `temporal` | PostgreSQL database name |

### DATABASE_URL

The Temporal service receives a `DATABASE_URL` in the format:

```
postgresql://user:password@host:port/database
```

The custom entrypoint script parses this URL and sets the individual environment variables that Temporal expects (`POSTGRES_USER`, `POSTGRES_PWD`, `POSTGRES_SEEDS`, `DB_PORT`, `POSTGRES_DB`).

The connection uses Docker's internal DNS (`postgresql-temporal`), so no external port exposure is required for the database.

### Dynamic Configuration

Dynamic configuration is stored in `config/dynamicconfig/development-sql.yaml`. This file is mounted into the Temporal container and allows runtime configuration of various Temporal parameters.

## Project Structure

```
.
├── docker-compose.yml
├── config/
│   └── dynamicconfig/
│       └── development-sql.yaml
└── containers/
    ├── temporal-server/
    │   └── Containerfile
    ├── temporal-admin-tools/
    │   └── Containerfile
    └── temporal-ui/
        └── Containerfile
```

## Containerfiles

Temporal services have their own Containerfile in the `containers/` directory. PostgreSQL uses the official image directly.

| Service | Base Image | Description |
|---------|------------|-------------|
| `postgresql-temporal` | `postgres:16-alpine` | PostgreSQL database (official image) |
| `temporal-server` | `temporalio/auto-setup:1.26.2` | Temporal server with PostgreSQL config |
| `temporal-admin-tools` | `temporalio/admin-tools:1.26.2` | CLI tools for administration |
| `temporal-ui` | `temporalio/ui:2.34.0` | Web UI for workflow visualization |

To build a specific image:

```bash
docker build -f containers/temporal-server/Containerfile -t my-temporal-server containers/temporal-server/
```

To build all images:

```bash
docker compose build
```

## Ports

| Port | Service | Protocol | Exposed |
|------|---------|----------|---------|
| 7233 | Temporal gRPC | TCP | Host |
| 8080 | Temporal UI | HTTP | Host |
| 5432 | PostgreSQL | TCP | Internal only |

## Troubleshooting

### Services fail to start

Check if ports are already in use:

```bash
lsof -i :7233
lsof -i :8080
```

### Database connection issues

Verify PostgreSQL is healthy:

```bash
docker compose exec postgresql-temporal pg_isready -U temporal
```

### View Temporal server logs

```bash
docker compose logs temporal
```

### Reset everything

```bash
docker compose down -v
docker compose up -d
```

## Resources

- [Temporal Documentation](https://docs.temporal.io/)
- [Temporal Docker Images](https://hub.docker.com/u/temporalio)
- [Temporal GitHub](https://github.com/temporalio/temporal)
