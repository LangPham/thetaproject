#!/bin/bash
# docker entrypoint script.

# assign a default for the database_user
DB_USER=${DATABASE_USER:-postgres}

# wait until Postgres is ready
while ! pg_isready -q -h $DATABASE_HOST -p 5432 -U $DB_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

#mix local.hex --force
#mix local.rebar --force

# Initial setup
#mix deps.get
#
#MIX_ENV=prod mix compile
#
#yarn --cwd ./apps/campus_web/assets install
#yarn --cwd ./apps/campus_web/assets deploy

MIX_ENV=prod mix theta_install
MIX_ENV=prod mix phx.server