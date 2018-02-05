# Jonne

A simple Elasticsearch->Slack alerting tool written in Elixir.

## Features and non-features

- Indices are assumed to be named per date in the "logstash format", e.g. `my-index-2018.01.31`
- Indices are queried according to the client time in UTC
- Stateless, only messages arriving after Jonne starts up are delivered
- Exposes Prometheus metrics at `http://localhost:9001/metrics`

## TODO

- Alert message extraction / formatting should be configurable
- Buffer unsent messages
- Don't repeat the same message (buffering in notifier?)

## Usage

```bash
brew install elixir

# Run app in development mode
mix run --no-halt

# Run unit tests
mix test

# Start application in REPL
iex -S mix

iex> r Jonne.Poller              # Reload module
iex> Application.start(:jonne)   # Restart app after crash

# Build and run in Docker
docker build -t jonne .
docker run --env-file .env jonne
```
