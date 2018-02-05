use Mix.Config

config :jonne,
  elasticsearch_url: "${ELASTICSEARCH_URL}",
  elasticsearch_index_prefix: "${ELASTICSEARCH_INDEX_PREFIX}",
  elasticsearch_query: "${ELASTICSEARCH_QUERY}",
  elasticsearch_poll_interval: "${ELASTICSEARCH_POLL_INTERVAL}",
  slack_webhook_url: "${SLACK_WEBHOOK_URL}"
