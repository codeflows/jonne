defmodule Jonne.Notifier do
  use GenServer
  require Logger

  @slack_webhook_url Application.fetch_env!(:jonne, :slack_webhook_url)

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: Jonne.Notifier)
  end

  def notify(document) do
    GenServer.cast(Jonne.Notifier, document)
  end

  def init(:ok) do
    {:ok, []}
  end

  def handle_cast(document, _state) do
    text = document["_source"]["message"]
    case HTTPoison.post(
           @slack_webhook_url,
           # TODO jari: make mapping from document to alert text configurable
           Poison.encode!(%{text: text}),
           Accept: "application/json"
         ) do
      {:ok, %{status_code: 200}} ->
        Logger.debug("Sent notification for #{inspect text} successfully")

      error ->
        Logger.error("Error sending Slack notification: #{inspect(error)}")
    end

    {:noreply, []}
  end
end