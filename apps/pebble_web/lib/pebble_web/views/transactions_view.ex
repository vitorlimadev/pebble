defmodule PebbleWeb.TransactionsView do
  use PebbleWeb, :view

  def render("transaction.json", %{transaction: transaction}) do
    %{
      account: %{
        id: transaction.id,
        sender_id: transaction.sender_id,
        receiver_id: transaction.receiver_id,
        value: transaction.value
      }
    }
  end

  def render("invalid_info.json", %{}) do
    %{
      error: "Invalid info."
    }
  end

  def render("insuficient_funds.json", %{difference: difference}) do
    %{
      error: "R$ #{div(difference, 100)} is missing to fullfil the transaction."
    }
  end

  def render("not_found.json", %{}) do
    %{
      error: "One of the accounts was not found."
    }
  end
end
