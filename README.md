# Jonne

[![Build status](https://api.travis-ci.org/codeflows/jonne.svg?branch=master)](https://travis-ci.org/codeflows/jonne)

Jonne queries Elasticsearch and sends notifications for matching documents.
Written in Elixir as a learning project.

## Features

- Stateless: only messages arriving after the app starts up are delivered
- Indices are assumed to be named per date in the "logstash format", e.g. `my-index-2018.01.31`
- Indices are queried according to the client time in UTC
- Slack notifications are sent for matching documents
- Prometheus metrics exposed at `http://localhost:9001/metrics`

## Usage

Start via Docker:

`docker run --env-file my-env codeflows/jonne`

where `my-env` contains

```
# Required parameters
ELASTICSEARCH_URL=http://your-elasticsearch:9200
ELASTICSEARCH_INDEX_PREFIX=my-index-
ELASTICSEARCH_QUERY=service:loadbalancer AND \"hello world\"
ELASTICSEARCH_POLL_INTERVAL=15000
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/TODO

# Optional parameters

# Slack notification EEx template
SLACK_NOTIFICATION_TEMPLATE=Got document from index <%= document[\"_index\"] %>
```

## Limitations and future ideas

- Currently you can only have one query per instance
- tzdata is downloaded on every startup inside the Docker container
- Notifier does not buffer events but alerts on every one - don't repeat messages?

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

# Build, tag and push a new Docker release
./docker-release.sh 1.0.0
```
