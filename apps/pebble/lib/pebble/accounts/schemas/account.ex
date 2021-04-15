defmodule Pebble.Accounts.Schemas.Account do
  @moduledoc """
  The account of a user registered in the Pebble bank.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @possible_params [:name, :email, :cpf, :password]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :name, :string
    field :email, :string
    field :cpf, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :balance, :integer

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @possible_params)
    |> change(Argon2.add_hash(params.password))
  end
end
