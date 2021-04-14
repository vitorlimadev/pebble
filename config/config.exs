# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :pebble,
  ecto_repos: [Pebble.Repo]

config :pebble_web,
  ecto_repos: [Pebble.Repo],
  generators: [context_app: :pebble, binary_id: true]

# Configures the endpoint
config :pebble_web, PebbleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rGH0EUWcSAu9VEr50n2msT5YuMUD82cEMXRbIWEeDmKHLaWScUtfojL6Ycz7mGbk",
  render_errors: [view: PebbleWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Pebble.PubSub,
  live_view: [signing_salt: "+XONtKiE"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
