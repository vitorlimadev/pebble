defmodule Pebble.Repo.Migrations.CreateTransactionTable do
  use Ecto.Migration

  def change do
    create table :transactions, primary_key: false do
      add :id, :uuid, primary_key: true
      add :sender_id, references(:accounts, type: :uuid)
      add :receiver_id, references(:accounts, type: :uuid)
      add :value, :integer

      timestamps()
    end

    create index(:transactions, [:sender_id])
    create index(:transactions, [:receiver_id])
  end
end
