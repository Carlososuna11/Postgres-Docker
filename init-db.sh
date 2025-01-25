#!/bin/bash
set -e

# Enable the pgvector extension in the specified database
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE EXTENSION IF NOT EXISTS vector;"