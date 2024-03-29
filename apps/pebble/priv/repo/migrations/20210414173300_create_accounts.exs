defmodule Pebble.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table :accounts, primary_key: false do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :email, :string
      add :password, :string
      add :cpf, :string
      add :balance, :integer, default: 100000
      
      timestamps()
    end

    create unique_index(:accounts, [:cpf])
    create unique_index(:accounts, [:email])
  end
end
