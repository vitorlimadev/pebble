defmodule PebbleWeb.AccountsController do
  @moduledoc """
  Web layer for the Account resource.
  """
  use PebbleWeb, :controller

  alias Pebble.Accounts

  def create(conn, params) do
    params
    |> Accounts.create_account()
    |> case do
      {:ok, _account} -> send_resp(conn, 200, "ok")
      {:error, _error} -> send_resp(conn, 400, "meh")
    end
  end
end
