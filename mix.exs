defmodule Pebble.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.4", only: [:test, :dev], runtime: false}
    ]
  end

  defp aliases do
    [
      setup: ["cmd mix setup"]
    ]
  end
end
