defmodule PebbleWeb.AccountsView do
  use PebbleWeb, :view

  def render("account.json", %{account: account}) do
    %{
      account: %{
        id: account.id,
        name: account.name,
        email: account.email,
        cpf: account.cpf,
        balance: account.balance,
        inserted_at: account.inserted_at,
        updated_at: account.updated_at
      }
    }
  end

  def render("already_taken.json", %{key: key}) do
    %{
      error: "#{key} already registered."
    }
  end

  def render("invalid_info.json", %{}) do
    %{
      error: "Invalid params."
    }
  end

  def render("not_found.json", %{}) do
    %{
      error: "Account not found."
    }
  end
end
