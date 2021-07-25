defmodule Pebble.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Watcher,
      Pebble.Repo,
      {Phoenix.PubSub, name: Pebble.PubSub}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Pebble.Supervisor)
  end
end
