defmodule PebbleWeb.TransactionsController do
  @moduledoc """
  Web layer for the Transaction resource.
  """
  use PebbleWeb, :controller

  alias Pebble.Transactions

  def create(conn, %{
        "value" => value,
        "sender_id" => sender_id,
        "receiver_id" => receiver_id
      }) do
    Transactions.send_money(%{
      value: value,
      sender_id: sender_id,
      receiver_id: receiver_id
    })
    |> case do
      {:ok, transaction} ->
        send_json(conn, 201, "transaction.json", transaction: transaction)

      {:error, error} ->
        case error do
          :invalid_info ->
            send_json(conn, 400, "invalid_info.json")

          :not_found ->
            send_json(conn, 400, "not_found.json")

          {:missing_funds, difference} ->
            send_json(conn, 400, "insuficient_funds.json", difference: difference)
        end
    end
  end

  def show(conn, %{"id" => id}) do
    id
    |> Transactions.get_transaction()
    |> case do
      {:ok, transaction} ->
        send_json(conn, 200, "transaction.json", transaction: transaction)

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
