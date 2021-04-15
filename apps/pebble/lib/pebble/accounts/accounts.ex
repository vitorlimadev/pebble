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
  @spec create_account(map) ::
          {:ok, Account.t()} | {:error, :invalid_info | :cpf_conflict | :email_conflict}
  def create_account(params) do
    with %{valid?: true, changes: changes} <- Inputs.Create.changeset(params),
         %{valid?: true} = unique <- Account.changeset(changes),
         {:ok, account} <- Repo.insert(unique) do
      Logger.info("Sua conta foi criada. Parabéns #{account.name}!")
      {:ok, account}
    else
      %{valid?: false} = changeset ->
        Logger.error("Informações incorretas. Erro: #{inspect(changeset)}")
        {:error, :invalid_info}
    end
  rescue
    error in Ecto.ConstraintError ->
      case error do
        %{constraint: "accounts_cpf_index"} ->
          Logger.error("Este CPF já está cadastrado.")
          {:error, :cpf_conflict}

        %{constraint: "accounts_email_index"} ->
          Logger.error("Este email já está cadastrado.")
          {:error, :email_conflict}
      end
  end
end
