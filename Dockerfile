# Use the official PostgreSQL image as the base
FROM postgres:15

# Install necessary tools and the pgvector extension
RUN apt-get update && apt-get install -y \
    postgresql-15-pgvector \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy an initialization script to enable the extension
COPY init-db.sh /docker-entrypoint-initdb.d/

# Define the entry point
CMD ["postgres"]