defmodule Jonne.Coordinator do
  use GenServer
  require Logger
  alias Jonne.{Searcher, Slack.Notifier, Statistics.MessageCounter}

  def start_link(_opts) do
    Logger.info("Coordinator starting up, poll interval #{poll_interval()}ms")
    GenServer.start_link(__MODULE__, :ok, name: Jonne.Coordinator)
  end

  def init(:ok) do
    initial_position = Searcher.get_initial_position(Timex.now())
    schedule_next_round(0)
    {:ok, initial_position}
  end

  def handle_info(:poll, position) do
    %{position: new_position, hits: hits} = Searcher.get_new_messages(Timex.now(), position)

    Enum.each(hits, fn document ->
      Notifier.notify(document)
      MessageCounter.increase_message_count()
    end)

    schedule_next_round()
    {:noreply, new_position}
  end

  defp schedule_next_round(delay_in_ms \\ poll_interval()) do
    Process.send_after(self(), :poll, delay_in_ms)
  end

  defp poll_interval() do
    interval = Application.get_env(:jonne, :elasticsearch_poll_interval, "10000")
    String.to_integer(interval)
  end
end
