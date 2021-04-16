defmodule Pebble.Transactions do
  @moduledoc """
  Functions to directly manipulate/fetch data from the Transactions resource in the database.
  """

  require Logger
  alias Pebble.Repo
  alias Pebble.Accounts.Schemas.Account
  alias Pebble.Transactions.Schemas.Transaction

  @doc """
  Creates a new transaction between two accounts.

  It will fail if:
  * One of the accounts doesn't exist.
  * The sender account doesn't have enough money in it's balance.

  The :missing_funds error returns the amount missing from the account's balance.

  iex> Transaction.changeset(%{
             value: 12000,
             sender_id: "a valid UUID",
             receiver_id: "a valid UUID"
           })
  """
  @spec send_money(%{
          binary => non_neg_integer(),
          binary => binary,
          binary => binary
        }) ::
          {:ok, Transaction.t()}
          | {:error, :invalid_id | :account_not_found | {:missing_funds, integer}}
  def send_money(%{
        "value" => value,
        "sender_id" => sender_id,
        "receiver_id" => receiver_id
      }) do
    # Validating IDs
    with _ <- Ecto.UUID.cast!(sender_id),
         _ <- Ecto.UUID.cast(receiver_id),
         # Getting resources from Repo
         sender_account <- Repo.get!(Account, sender_id),
         receiver_account <- Repo.get!(Account, receiver_id),
         # Validating transaction
         %{valid?: true} = changeset <-
           Transaction.changeset(%{
             value: value,
             sender_id: sender_account.id,
             receiver_id: receiver_account.id
           }) do
      # Verifying sender's balance
      if sender_account.balance >= value do
        # Updating accounts balances
        updated_sender_account =
          Ecto.Changeset.change(sender_account, balance: sender_account.balance - value)

        updated_receiver_account =
          Ecto.Changeset.change(receiver_account, balance: receiver_account.balance + value)

        Repo.update(updated_sender_account)
        Repo.update(updated_receiver_account)

        Logger.info("Email: You sent R$ #{value / 100} to #{receiver_account.name}!")
        Repo.insert(changeset)
      else
        {:error, {:missing_funds, value - sender_account.balance}}
      end
    end
  rescue
    e in Ecto.CastError ->
      IO.inspect(e)
      {:error, :invalid_id}

    e in Ecto.NoResultsError ->
      IO.inspect(e)
      {:error, :account_not_found}
  end

  # @doc """
  # Return an transaction from the database.

  # It will fail if:
  # * ID is invalid.
  # * User doesn't exist.

  # iex> Accounts.get_account("b768add8-3223-4355-a127-bdbfe404a353")
  # """
  # @spec get_transaction(binary) :: {:ok, Account.t()} | {:error, :invalid_info | :not_found}
  # def get_account(account_id) do
  #   case Ecto.UUID.cast(account_id) do
  #     {:ok, _} ->
  #       case Repo.get(Account, account_id) do
  #         nil -> {:error, :not_found}
  #         account -> {:ok, account}
  #       end

  #     :error ->
  #       {:error, :invalid_info}
  #   end
  # end
end
