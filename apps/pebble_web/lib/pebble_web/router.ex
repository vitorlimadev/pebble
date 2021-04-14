defmodule PebbleWeb.Router do
  use PebbleWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PebbleWeb do
    pipe_through :api
  end
end
