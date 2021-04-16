defmodule PebbleWeb.Router do
  use PebbleWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PebbleWeb do
    pipe_through :api

    # Accounts
    post "/accounts", AccountsController, :create
    get "/accounts/:id", AccountsController, :show
    delete "/accounts/:id", AccountsController, :delete
    # Transactions
    post "/transactions", TransactionsController, :create
    get "/transactions/:id", AccountsController, :show
  end
end
