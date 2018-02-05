defmodule Jonne.Application do
  use Application

  def start(_type, _args) do
    children = [
      Jonne.Notifier,
      Jonne.Coordinator,
      Plug.Adapters.Cowboy2.child_spec(scheme: :http, plug: Jonne.Statistics.PrometheusExporter, options: [port: 9001])
    ]

    opts = [strategy: :one_for_one, name: Jonne.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
