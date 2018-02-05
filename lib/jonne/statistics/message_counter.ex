defmodule Jonne.Statistics.MessageCounter do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  def increase_message_count() do
    Agent.get_and_update(__MODULE__, fn state ->
      {:ok, state + 1}
    end)
  end

  def get_message_count() do
    Agent.get(__MODULE__, fn state -> state end)
  end
end
