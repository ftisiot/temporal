#!/bin/bash
set -e

# Parse DATABASE_URL and export individual environment variables for Temporal
# Format: postgresql://user:password@host:port/database

if [ -n "$DATABASE_URL" ]; then
    # Remove the protocol prefix
    url="${DATABASE_URL#postgresql://}"

    # Extract user:password
    userpass="${url%%@*}"
    export POSTGRES_USER="${userpass%%:*}"
    export POSTGRES_PWD="${userpass#*:}"

    # Extract host:port/database
    hostportdb="${url#*@}"

    # Extract host:port
    hostport="${hostportdb%%/*}"
    export POSTGRES_SEEDS="${hostport%%:*}"
    export DB_PORT="${hostport#*:}"

    # Extract database name
    export POSTGRES_DB="${hostportdb#*/}"

    echo "Parsed DATABASE_URL:"
    echo "  POSTGRES_SEEDS: $POSTGRES_SEEDS"
    echo "  DB_PORT: $DB_PORT"
    echo "  POSTGRES_USER: $POSTGRES_USER"
    echo "  POSTGRES_DB: $POSTGRES_DB"
fi

# Ensure DB type is set for PostgreSQL
export DB="${DB:-postgres12}"
echo "  DB: $DB"

# Execute the original entrypoint from the base image
exec /etc/temporal/auto-setup.sh
