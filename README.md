# Temporal Server with PostgreSQL Backend

A minimal Docker Compose setup for running [Temporal](https://temporal.io/) server with PostgreSQL as the persistence backend.

## Services

| Service | Description | Port |
|---------|-------------|------|
| `temporal` | Temporal server (gRPC API) | 7233 |
| `temporal-ui` | Temporal Web UI | 8080 |
| `postgresql-temporal` | PostgreSQL database | 5432 |

## Prerequisites

- Docker Engine 20.10+
- Docker Compose v2.0+

## Quick Start

```bash
docker compose up -d
```

- Temporal UI: http://localhost:8080
- Temporal gRPC: `localhost:7233`
- PostgreSQL: `localhost:5432`

## Usage

```bash
# Start
docker compose up -d

# View logs
docker compose logs -f

# Stop
docker compose down

# Stop and remove data
docker compose down -v
```

## Configuration

### Environment Variables

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

The entrypoint script parses this URL into individual environment variables for Temporal.

## Project Structure

```
.
├── docker-compose.yml
├── config/
│   └── dynamicconfig/
│       └── development-sql.yaml
└── containers/
    └── temporal-server/
        ├── Containerfile
        └── entrypoint.sh
```

## Resources

- [Temporal Documentation](https://docs.temporal.io/)
- [Temporal Docker Images](https://hub.docker.com/u/temporalio)
