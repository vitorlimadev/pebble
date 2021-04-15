defmodule PebbleWeb.TransactionsController do
  @moduledoc """
  Web layer for the Transaction resource.
  """
  use PebbleWeb, :controller

  alias Pebble.Transactions

  def create(conn, params) do
    params
    |> Transactions.send_money()
    |> case do
      {:ok, transaction} ->
        send_json(conn, 201, "transaction.json", transaction: transaction)

      {:error, error} ->
        case error do
          :invalid_sender ->
            send_json(conn, 400, "invalid_account.json", account: "Sender")

          :invalid_reciever ->
            send_json(conn, 400, "invalid_account.json", account: "Receiver")

          :insuficient_funds ->
            send_json(conn, 400, "insuficient_funds.json")
        end
    end
  end

  defp send_json(conn, status, view, opts \\ %{}) do
    conn
    |> put_status(status)
    |> render(view, opts)
  end
end
