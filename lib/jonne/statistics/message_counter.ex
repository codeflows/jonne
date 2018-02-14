defmodule Jonne.Statistics.MessageCounter do
  use Agent
  @behaviour Jonne.Consumer

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  def consume(_document), do: increase_message_count()

  def get_message_count() do
    Agent.get(__MODULE__, fn state -> state end)
  end

  defp increase_message_count() do
    Agent.get_and_update(__MODULE__, fn state ->
      {:ok, state + 1}
    end)
  end
end
