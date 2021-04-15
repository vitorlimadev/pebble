defmodule PebbleWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :pebble_web

  @session_options [
    store: :cookie,
    key: "_pebble_web_key",
    signing_salt: "ChVb3Ag6"
  ]

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :pebble_web
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug PebbleWeb.Router
end
