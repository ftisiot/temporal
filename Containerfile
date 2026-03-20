# Temporal Server with PostgreSQL backend
# Based on the official Temporal auto-setup image

FROM temporalio/auto-setup:1.26.2

LABEL maintainer="your-email@example.com"
LABEL description="Temporal Server configured for PostgreSQL backend"
LABEL version="1.26.2"

# Set environment variables for PostgreSQL backend
ENV DB=postgres12
ENV DB_PORT=5432
ENV POSTGRES_SEEDS=postgresql
ENV DYNAMIC_CONFIG_FILE_PATH=config/dynamicconfig/development-sql.yaml

# Create directory for dynamic config
RUN mkdir -p /etc/temporal/config/dynamicconfig

# Copy dynamic config if needed (mounted via volume in docker-compose)
# COPY config/dynamicconfig/development-sql.yaml /etc/temporal/config/dynamicconfig/

# Expose Temporal gRPC port
EXPOSE 7233

# Health check
HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=10 \
    CMD tctl --address localhost:7233 cluster health || exit 1
