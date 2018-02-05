use Mix.Config

config :jonne,
  elasticsearch_url: "http://localhost:9200",
  elasticsearch_index_prefix: "my-index-",
  elasticsearch_query: "some error",
  elasticsearch_poll_interval: 5000,
  slack_webhook_url: "https://hooks.slack.com/services/TODO"
