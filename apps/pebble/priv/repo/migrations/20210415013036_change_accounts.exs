defmodule Pebble.Repo.Migrations.ChangeAccounts do
  use Ecto.Migration

  def change do
    alter table "accounts" do
      remove :password
      add :password_hash, :string
    end
  end
end
