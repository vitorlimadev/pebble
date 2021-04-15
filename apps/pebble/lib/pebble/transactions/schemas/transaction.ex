defmodule Pebble.Transactions.Schemas.Transaction do
  @moduledoc """
  The transaction abstract resource.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_params [:sender_id, :receiver_id, :value]
  @optional_params []

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :sender_id, :binary_id
    field :receiver_id, :binary_id
    field :value, :integer

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
  end
end
