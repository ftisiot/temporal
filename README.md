# Temporal Server with PostgreSQL Backend

A Docker Compose setup for running [Temporal](https://temporal.io/) server with PostgreSQL as the persistence backend.

## Services

| Service | Description | Port |
|---------|-------------|------|
| `temporal` | Temporal server (gRPC API) | 7233 |
| `temporal-ui` | Temporal Web UI | 8080 |
| `temporal-admin-tools` | CLI tools for administration | - |
| `postgresql` | PostgreSQL database | 5432 |

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

The following environment variables can be customized in `docker-compose.yml`:

| Variable | Default | Description |
|----------|---------|-------------|
| `POSTGRES_USER` | `temporal` | PostgreSQL username |
| `POSTGRES_PWD` | `temporal` | PostgreSQL password |
| `POSTGRES_SEEDS` | `postgresql` | PostgreSQL host |
| `DB_PORT` | `5432` | PostgreSQL port |

### Dynamic Configuration

Dynamic configuration is stored in `config/dynamicconfig/development-sql.yaml`. This file is mounted into the Temporal container and allows runtime configuration of various Temporal parameters.

## Containerfile

The included `Containerfile` extends the official `temporalio/auto-setup` image with:

- Pre-configured PostgreSQL backend settings
- Health check configuration
- Dynamic config directory setup

To build a custom image:

```bash
docker build -f Containerfile -t my-temporal-server .
```

## Ports

| Port | Service | Protocol |
|------|---------|----------|
| 7233 | Temporal gRPC | TCP |
| 8080 | Temporal UI | HTTP |
| 5432 | PostgreSQL | TCP |

## Troubleshooting

### Services fail to start

Check if ports are already in use:

```bash
lsof -i :7233
lsof -i :8080
lsof -i :5432
```

### Database connection issues

Verify PostgreSQL is healthy:

```bash
docker compose exec postgresql pg_isready -U temporal
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
