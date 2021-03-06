use Mix.Config

config :jonne,
  elasticsearch_url: "${ELASTICSEARCH_URL}",
  elasticsearch_index_prefix: "${ELASTICSEARCH_INDEX_PREFIX}",
  elasticsearch_query: "${ELASTICSEARCH_QUERY}",
  elasticsearch_poll_interval: "${ELASTICSEARCH_POLL_INTERVAL}",
  slack_webhook_url: "${SLACK_WEBHOOK_URL}",
  slack_notification_template: "${SLACK_NOTIFICATION_TEMPLATE}"

# Override tzdata download directory in Docker
config :tzdata, :data_dir, "./tzdata"
