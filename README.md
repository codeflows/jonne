# Jonne

Jonne queries Elasticsearch and sends notifications for matching documents.
Written in Elixir as a learning project.

## Features

- Stateless: only messages arriving after the app starts up are delivered
- Indices are assumed to be named per date in the "logstash format", e.g. `my-index-2018.01.31`
- Indices are queried according to the client time in UTC
- Slack notifications are sent for matching documents
- Prometheus metrics exposed at `http://localhost:9001/metrics`

## Configuration and usage

To run in Docker, build the image (instructions below) and provide configuration in environment variables (e.g. via `docker run --env-file .env`):

```
ELASTICSEARCH_URL=http://your-elasticsearch:9200
ELASTICSEARCH_INDEX_PREFIX=my-index-
ELASTICSEARCH_QUERY=some query
ELASTICSEARCH_POLL_INTERVAL=15000
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...
```

## Future ideas

- Alert message extraction / formatting should be configurable
- Generalize notification consumers e.g. using Protocols
- tzdata is downloaded on every startup
- Buffer unsent messages
- Don't repeat the same message (buffering in notifier?)

## Development

Copy `config/dev.template.exs` to `config/dev.exs` and customize.

```bash
brew install elixir

# Get dependencies
mix deps.get

# Run app in development mode
mix run --no-halt

# Run unit tests
mix test

# Start application in REPL
iex -S mix

iex> r Jonne.Poller              # Reload module
iex> Application.start(:jonne)   # Restart app after crash

# Build a production release
MIX_ENV=prod mix release

# Build & run a release in Docker
docker build -t jonne .
docker run --env-file .env jonne
```
