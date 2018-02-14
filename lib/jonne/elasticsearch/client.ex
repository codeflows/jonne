defmodule Jonne.Elasticsearch.Client do
  @callback search(url :: String.t(), indices :: [String.t()], payload: %{}) :: [%{}]
end

defmodule Jonne.Elasticsearch.HttpClient do
  @behaviour Jonne.Elasticsearch.Client

  def search(url, indices, payload) do
    indices_string = Enum.join(indices, ",")

    case HTTPoison.post!(
           "#{url}/#{indices_string}/_search?ignore_unavailable=true",
           Poison.encode!(payload),
           Accept: "application/json"
         ) do
      %{status_code: 200, body: body} ->
        result = Poison.decode!(body)
        hits = result["hits"]["hits"]
        {:hits, hits}
    end
  end
end
