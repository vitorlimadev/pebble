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
        send_json(conn, 201, "account.json", account: account)

      {:error, error} ->
        case error do
          :email_conflict ->
            send_json(conn, 400, "already_taken.json", key: "Email")

          :cpf_conflict ->
            send_json(conn, 400, "already_taken.json", key: "CPF")

          :invalid_info ->
            send_json(conn, 400, "invalid_info.json")
        end
    end
  end

  def show(conn, %{"id" => id}) do
    id
    |> Accounts.get_account()
    |> case do
      {:ok, account} ->
        send_json(conn, 200, "account.json", account: account)

      {:error, :invalid_info} ->
        send_json(conn, 400, "invalid_info.json")

      {:error, :not_found} ->
        send_json(conn, 400, "not_found.json")
    end
  end

  defp send_json(conn, status, view, opts \\ %{}) do
    conn
    |> put_status(status)
    |> render(view, opts)
  end
end
