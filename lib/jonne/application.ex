defmodule Jonne.Application do
  use Application

  def start(_type, _args) do
    children = [
      Jonne.Slack.Notifier,
      Jonne.Coordinator,
      Jonne.Statistics.Supervisor
    ]

    opts = [strategy: :one_for_one, name: Jonne.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
