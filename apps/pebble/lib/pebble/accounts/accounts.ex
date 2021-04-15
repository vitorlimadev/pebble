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
      {:ok, account}
    else
      %{valid?: false} = changeset ->
        {:error, :invalid_info}
    end
  rescue
    error in Ecto.ConstraintError ->
      case error do
        %{constraint: "accounts_cpf_index"} ->
          {:error, :cpf_conflict}

        %{constraint: "accounts_email_index"} ->
          {:error, :email_conflict}
      end
  end

  @doc """
  Return an account from the database.

  It will fail if:
  * ID is invalid.
  * User doesn't exist.

  iex> Accounts.get_account("b768add8-3223-4355-a127-bdbfe404a353")
  """
  @spec get_account(binary) :: {:ok, Account.t()} | {:error, :invalid_info | :not_found}
  def get_account(account_id) do
    case Ecto.UUID.cast(account_id) do
      {:ok, _} ->
        case Repo.get(Account, account_id) do
          nil -> {:error, :not_found}
          account -> {:ok, account}
        end

      :error ->
        {:error, :invalid_info}
    end
  end

  @doc """
  Removes an account from the database.

  It will fail if:
  * ID is invalid.
  * User doesn't exist.

  iex> Accounts.get_account("b768add8-3223-4355-a127-bdbfe404a353")
  """
  @spec delete_account(binary) :: {:ok, binary} | {:error, :invalid_info | :not_found}
  def delete_account(account_id) do
    case get_account(account_id) do
      {:ok, account} -> Repo.delete(account)
      {:error, error} -> {:error, error}
    end
  end
end
