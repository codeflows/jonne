defmodule Jonne.Mixfile do
  use Mix.Project

  def project do
    [
      app: :jonne,
      version: "0.2.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: [test: "test --no-start"]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :tzdata, :cowboy, :eex],
      mod: {Jonne.Application, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:timex, "~> 3.1"},
      {:cowboy, "~> 2.2"},
      {:plug, "~> 1.5.0-rc.1"},
      {:distillery, "~> 1.5"},
      {:mox, "~> 0.3", only: :test}
    ]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]
end
