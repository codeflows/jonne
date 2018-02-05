defmodule Jonne.Statistics do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/metrics" do
    send_resp(conn, 200,
      """
      # HELP matching_messages_total Total number of matching messages
      # TYPE matching_messages_total counter
      matching_messages_total 1
      """
    )
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
