defmodule Pebble.Accounts do
  @moduledoc """
  Functions to directly manipulate/fetch data from the Accounts resource in the database.
  """

  require Logger
  alias Pebble.Repo
  alias Pebble.Accounts.Schemas.Account
  alias Pebble.Accounts.Inputs

  @doc """
  Creates a new account.

  It will fail if:
  * Params are missing.
  * Email is already taken. 
  * CPF is already taken.

  iex> Accounts.create_account(%{
    name: "Joe",
    email: "joe@test.com",
    cpf: "000.000.000-00",
  })
  """
  @spec create_account(Inputs.Create.t()) ::
          {:ok, Account.t()} | {:error, Ecto.Changeset.t() | :cpf_conflict | :email_conflict}
  def create_account(%Inputs.Create{} = input) do
    params = %{
      name: input.name,
      email: input.email,
      email_confirmation: input.email_confirmation,
      password: input.password,
      cpf: input.cpf
    }

    with %{valid?: true} = changeset <- Account.changeset(params),
         {:ok, account} <- Repo.insert(changeset) do
      Logger.info("Sua conta foi criada. Parabéns #{account.name}!")
      {:ok, account}
    else
      %{valid?: false} = changeset ->
        Logger.error("Tivemos um problema ao criar sua conta. Erro: #{inspect(changeset)}")
        {:error, changeset}
    end
  rescue
    error in Ecto.ConstraintError ->
      case error do
        %{constraint: "accounts_cpf_index"} ->
          Logger.error("Este CPF já está cadastrado.")
          {:error, :cpf_conflict}

        %{constraint: "accounts_email_index"} ->
          Logger.error("Este email já está cadastrado.")
          {:error, "Este CPF já está cadastrado"}
      end
  end
end
