defmodule Jonne.Notifier do
  use GenServer
  require Logger

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
    slack_notification = %{
      # TODO jari: make mapping from document to alert text configurable
      text: text,
      username: "jonne",
      icon_emoji: ":sunglasses:"
    }
    case HTTPoison.post(
           slack_webhook_url(),
           Poison.encode!(slack_notification),
           Accept: "application/json"
         ) do
      {:ok, %{status_code: 200}} ->
        Logger.debug("Sent notification for #{inspect text} successfully")

      error ->
        Logger.error("Error sending Slack notification: #{inspect(error)}")
    end

    {:noreply, []}
  end

  defp slack_webhook_url() do; Application.get_env(:jonne, :slack_webhook_url); end
end
