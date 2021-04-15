defmodule Pebble.TransactionsTest do
  use Pebble.DataCase, async: true

  alias Pebble.Accounts
  alias Pebble.Transactions

  describe "send_money/1" do
    test "ensure money is sent as expected" do
      value = Enum.random(100..100_000)

      sender_info = %{
        name: "Joe Doe",
        email: "joedoe@test.com",
        email_confirmation: "joedoe@test.com",
        password: "12345678",
        cpf: "123.456.789-01"
      }

      receiver_info = %{
        name: "Jane Doe",
        email: "janedoe@test.com",
        email_confirmation: "janedoe@test.com",
        password: "12345678",
        cpf: "123.456.789-02"
      }

      {:ok, sender_account} = Accounts.create_account(sender_info)
      {:ok, receiver_account} = Accounts.create_account(receiver_info)

      {:ok, transaction} =
        Transactions.send_money(%{
          value: value,
          sender_account: sender_account,
          receiver_account: receiver_account
        })

      assert transaction.sender_id == sender_account.id
      assert transaction.receiver_id == receiver_account.id
      assert transaction.value == value
    end

    test "yields error when sender has insuficient funds" do
      value = 1000

      sender_info = %{
        name: "Joe Doe",
        email: "joedoe@test.com",
        email_confirmation: "joedoe@test.com",
        password: "12345678",
        cpf: "123.456.789-01"
      }

      receiver_info = %{
        name: "Jane Doe",
        email: "janedoe@test.com",
        email_confirmation: "janedoe@test.com",
        password: "12345678",
        cpf: "123.456.789-02"
      }

      {:ok, sender} = Accounts.create_account(sender_info)

      sender_account = Map.put(sender, :balance, value - 100)

      {:ok, receiver} = Accounts.create_account(receiver_info)

      receiver_account = Map.put(receiver, :balance, value)

      assert {:error, :insuficient_funds} =
               Transactions.send_money(%{
                 value: value,
                 sender_account: sender_account,
                 receiver_account: receiver_account
               })
    end
  end
end
