defmodule PebbleWeb.AccountsView do
  use PebbleWeb, :view

  def render("create.json", %{account: account}) do
    %{
      account: %{
        id: account.id,
        name: account.name,
        email: account.email,
        cpf: account.cpf,
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

  def render("invalid_info.json", %{error: :invalid_info}) do
    %{
      error: "Invalid params."
    }
  end
end