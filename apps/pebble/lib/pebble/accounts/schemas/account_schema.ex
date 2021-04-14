defmodule Pebble.Accounts.Schemas.Account do
  @moduledoc """
  The account of a user registered in the Pebble bank.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_params [:name, :email, :cpf, :password]
  @optional_params []

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :name, :string
    field :email, :string
    field :cpf, :string
    field :password, :string

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> validate_length(:name, min: 2)
    |> validate_format(:cpf, ~r/^\d{3}\.\d{3}\.\d{3}\-\d{2}$/)
    |> validate_format(:email, ~r/[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+/)
  end
end
