# PostgreSQL Docker Configuration

> PostgreSQL is a powerful, open-source object-relational database system with over 35 years of active development. It has earned a strong reputation for reliability, feature robustness, and performance. Learn more at [PostgreSQL](https://www.postgresql.org/).

This repository contains configuration files and instructions for running PostgreSQL in Docker containers, including support for vector storage with the `pgvector` extension.

---

## Table of Contents

- [Setup](#setup)
  - [Step 1: Create a Docker Compose File](#step-1-create-a-docker-compose-file)
  - [Step 2: Create a Dockerfile](#step-2-create-a-dockerfile)
  - [Step 3: Add Initialization Script](#step-3-add-initialization-script)
  - [Step 4: Start PostgreSQL](#step-4-start-postgresql)
- [Database Management](#database-management)
  - [Create a Database](#create-a-database)
  - [Create a User](#create-a-user)
  - [Grant Permissions](#grant-permissions)
- [Useful Commands](#useful-commands)
- [Contributing](#contributing)
- [License](#license)

---

## Setup

### Step 1: Create a Docker Compose File

The `docker-compose.yml` file defines the PostgreSQL service configuration. Use the following configuration to create the file:

```yaml
version: '3.8'

services:
  db:
    container_name: "postgresql"
    build:
      context: .
    volumes:
      - postgres_data:/var/lib/postgresql/data/
    ports:
      - 5432:5432
    env_file:
      - ./.env
    networks:
      - postgres_go_net
    restart: always

volumes:
  postgres_data:

networks:
  postgres_go_net:
    driver: bridge
```

### Step 2: Create a Dockerfile

The `Dockerfile` specifies the custom PostgreSQL image with the `pgvector` extension. Use the following configuration:

```dockerfile
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
```

### Step 3: Add Initialization Script

Create an initialization script named `init-db.sh` to enable the `pgvector` extension in your PostgreSQL instance:

```bash
#!/bin/bash
set -e

# Enable the pgvector extension in the specified database
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE EXTENSION IF NOT EXISTS vector;"
```

Ensure the script has executable permissions:

```bash
chmod +x init-db.sh
```

### Step 4: Start PostgreSQL

Build the custom image and start the PostgreSQL service:

```bash
docker-compose build
docker-compose up -d
```

---

## Database Management

### Create a Database
To create a new database, connect to the PostgreSQL instance:

```bash
docker exec -it postgresql psql -U postgres
```

Once connected, run the following SQL command:

```sql
CREATE DATABASE yourdbname;
```

### Create a User
Create a new database user with the following command:

```sql
CREATE USER youruser WITH ENCRYPTED PASSWORD 'yourpass';
```

### Grant Permissions
Grant the new user access to the database:

```sql
GRANT ALL PRIVILEGES ON DATABASE yourdbname TO youruser;
```

---

## Useful Commands

### Access the PostgreSQL Container
```bash
docker exec -it postgresql psql -U postgres
```

### Backup a Database
```bash
docker exec -t postgresql pg_dump -U postgres yourdbname > backup.sql
```

### Restore a Database
```bash
docker exec -i postgresql psql -U postgres -d yourdbname < backup.sql
```

### Stop the PostgreSQL Container
```bash
docker-compose down
```

---

## Contributing

Contributions are welcome! Please fork this repository and submit a pull request with your changes. Ensure your updates align with the repository's purpose.
