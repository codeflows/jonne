defmodule Jonne.Application do
  use Application

  def start(_type, _args) do
    children = [Jonne.Notifier, Jonne.Coordinator]

    opts = [strategy: :one_for_one, name: Jonne.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
