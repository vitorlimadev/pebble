defmodule Pebble.Accounts.Inputs.Create do
  @moduledoc """
  Input data to call Accounts.create_account/1
  """

  use Ecto.Schema

  import Ecto.Changeset

  @required_params [:name, :email, :email_confirmation, :cpf, :password]
  @optional_params []

  @primary_key false
  embedded_schema do
    field :name, :string
    field :email, :string
    field :email_confirmation, :string
    field :cpf, :string
    field :password, :string

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> validate_length(:name, min: 2)
    |> validate_length(:password, min: 8)
    |> validate_format(:cpf, ~r/^\d{3}\.\d{3}\.\d{3}\-\d{2}$/)
    |> validate_format(:email, ~r/[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+/)
    |> validate_confirmation(:email)
    |> make_input_struct()
  end

  defp make_input_struct(%Ecto.Changeset{} = changeset) do
    struct(__MODULE__, changeset.changes)
  end
end
