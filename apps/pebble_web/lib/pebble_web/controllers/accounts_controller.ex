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
      {:ok, account} ->
        conn
        |> put_status(201)
        |> render("create.json", account: account)

      {:error, error} ->
        case error do
          :email_conflict ->
            conn
            |> put_status(400)
            |> render("already_taken.json", key: "Email")

          :cpf_conflict ->
            conn
            |> put_status(400)
            |> render("already_taken.json", key: "CPF")

          :invalid_info ->
            conn
            |> put_status(400)
            |> render("invalid_info.json", error: :invalid_info)
        end
    end
  end
end
