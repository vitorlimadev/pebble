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

  iex> Transactions.send_money()
  """

  @spec send_money(%{
          value: non_neg_integer(),
          sender_account: Account.t(),
          receiver_account: Account.t()
        }) ::
          {:ok, Transaction.t()}
          | {:error, :invalid_sender | :invalid_reciever | :insuficient_funds}
  def send_money(%{
        value: value,
        sender_account: %Account{} = sender_account,
        receiver_account: %Account{} = receiver_account
      }) do
    with {:sender_id, {:ok, _}} <-
           {:sender_id, Ecto.UUID.cast(sender_account.id)},
         {:receiver_id, {:ok, _}} <-
           {:receiver_id, Ecto.UUID.cast(receiver_account.id)},
         %{valid?: true} = changeset <-
           Transaction.changeset(%{
             value: value,
             sender_id: sender_account.id,
             receiver_id: receiver_account.id
           }) do
      if sender_account.balance >= value do
        Logger.info("You sent R$ #{value / 100} to #{receiver_account.name}!")
        Repo.insert(changeset)
      else
        {:error, :insuficient_funds}
      end
    else
      {:sender_id, :error} -> {:error, :invalid_sender}
      {:reciever_id, :error} -> {:error, :invalid_reciever}
    end
  end

  # @doc """
  # Return an account from the database.

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
