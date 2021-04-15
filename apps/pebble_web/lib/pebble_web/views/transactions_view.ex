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

  def render("invalid_account.json", %{account: account}) do
    %{
      error: "#{account} is invalid."
    }
  end

  def render("insuficient_funds.json", %{}) do
    %{
      error: "Sender account has insuficient funds."
    }
  end
end
