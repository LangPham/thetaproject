FROM elixir:1.10.3-alpine

# install build dependencies
RUN apk add --no-cache build-base nodejs yarn git bash openssl postgresql-client

# prepare build dir
WORKDIR /app

# copy source
COPY mix.exs mix.lock ./
COPY config config
COPY apps apps
COPY entrypoint.sh ./
RUN chmod a+x entrypoint.sh

# compile backend
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN MIX_ENV=prod mix compile

# compile frondent
RUN yarn --cwd ./apps/campus_web/assets install
RUN yarn --cwd ./apps/campus_web/assets deploy
RUN mix do theta_digest

EXPOSE 4041
