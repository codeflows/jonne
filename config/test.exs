use Mix.Config

config :jonne,
  elasticsearch_client: Jonne.Elasticsearch.MockClient,
  elasticsearch_url: "http://no_such_thing:9200",
  elasticsearch_index_prefix: "my-index-",
  elasticsearch_query: "bad hombre"
