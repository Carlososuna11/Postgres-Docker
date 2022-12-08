# PostgreSQL Docker Configuration

> PostgreSQL is a powerful, open source object-relational database system with over 35 years of active development that has earned it a strong reputation for reliability, feature robustness, and performance. [PostgreSQL](https://www.postgresql.org/)

This repository contains the configuration files for running postgreSQL in Docker containers. It is based on the [Baeldung](https://www.baeldung.com/ops/postgresql-docker-setup) tutorial.

## Configuration

1. Set up a Postgres container

   The Docker Compose file below will run everything for you via Docker.

```yml
version: '3.8'

services:
  db:
    image: postgres:13.0-alpine
    volumes:
      - postgres_data:/var/lib/postgresql/data/
    ports:
      - 5432:5432
    env_file:
      - ./.env

volumes:
  postgres_data:
```

2. Start the Postgres docker

   From a directory containing the `docker-compose.yml` file created in the previous step, run this command to start all services in the correct order.

```bash
docker-compose up -d
```