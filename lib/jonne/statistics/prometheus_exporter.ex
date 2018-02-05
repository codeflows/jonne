defmodule Jonne.Statistics.PrometheusExporter do
  use Plug.Router
  alias Jonne.Statistics.MessageCounter

  plug :match
  plug :dispatch

  get "/metrics" do
    count = MessageCounter.get_message_count()
    send_resp(conn, 200,
      """
      # HELP matching_messages_total Total number of matching messages
      # TYPE matching_messages_total counter
      matching_messages_total #{count}
      """
    )
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
