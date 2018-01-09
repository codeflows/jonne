use Mix.Config

config :jonne, :elasticsearch_client, Jonne.Elasticsearch.MockClient

config :jonne,
  elasticsearch_url: "http://no_such_thing:9200",
  elasticsearch_index_prefix: "my-index-",
  elasticsearch_query: "bad hombre",
  elasticsearch_poll_interval: 1000,
  slack_webhook_url: "https://slack_webhook"
