defmodule Jonne.Statistics.Supervisor do
  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      Jonne.Statistics.MessageCounter,
      # TODO jari: make port configurable
      {Plug.Adapters.Cowboy2, scheme: :http, plug: Jonne.Statistics.PrometheusExporter, options: [port: 9001]}
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
