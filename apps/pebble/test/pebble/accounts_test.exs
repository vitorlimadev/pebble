defmodule Pebble.AccountsTest do
  use Pebble.DataCase, async: true

  alias Pebble.Accounts

  describe "create_account/1" do
    test "create an account with correct data" do
      name = Ecto.UUID.generate()
      email = "#{Ecto.UUID.generate()}@test.com"
      password = Ecto.UUID.generate()
      cpf = "000.000.000-00"

      params = %{
        name: name,
        email: email,
        email_confirmation: email,
        password: password,
        cpf: cpf
      }

      assert {:ok, account} = Accounts.create_account(params)

      assert account.name == name
      assert account.email == email
      assert account.cpf == cpf
    end

    @tag capture_log: true
    test "yields error when CPF is invalid" do
      name = Ecto.UUID.generate()
      email = "#{Ecto.UUID.generate()}@test.com"
      password = Ecto.UUID.generate()
      cpf = "invalid CPF"

      params = %{
        name: name,
        email: email,
        email_confirmation: email,
        password: password,
        cpf: cpf
      }

      assert {:error, _} = Accounts.create_account(params)
    end

    @tag capture_log: true
    test "yields error when email is invalid" do
      name = Ecto.UUID.generate()
      email = "#{Ecto.UUID.generate()}test.com"
      password = Ecto.UUID.generate()
      cpf = "000.000.000-00"

      params = %{
        name: name,
        email: email,
        email_confirmation: email,
        password: password,
        cpf: cpf
      }

      assert {:error, _} = Accounts.create_account(params)
    end

    @tag capture_log: true
    test "yields error when email is already taken" do
      name = Ecto.UUID.generate()
      email = "#{Ecto.UUID.generate()}@te@st.com"
      password = Ecto.UUID.generate()
      cpf = "000.000.000-00"

      params = %{
        name: name,
        email: email,
        email_confirmation: email,
        password: password,
        cpf: cpf
      }

      Accounts.create_account(%{
        name: name,
        email: email,
        email_confirmation: email,
        password: password,
        cpf: "111.111.111-11"
      })

      assert {:error, :email_conflict} = Accounts.create_account(params)
    end

    @tag capture_log: true
    test "yields error when CPF is already taken" do
      name = Ecto.UUID.generate()
      email = "#{Ecto.UUID.generate()}@te@st.com"
      password = Ecto.UUID.generate()
      cpf = "000.000.000-00"

      params = %{
        name: name,
        email: email,
        email_confirmation: email,
        password: password,
        cpf: cpf
      }

      Accounts.create_account(%{
        name: name,
        email: "other@email.com",
        email_confirmation: "other@email.com",
        password: password,
        cpf: cpf
      })

      assert {:error, :cpf_conflict} = Accounts.create_account(params)
    end
  end

  describe "get_account/1" do
    test "returns the correct user if a valid id is given" do
      name = Ecto.UUID.generate()
      email = "#{Ecto.UUID.generate()}@test.com"
      password = Ecto.UUID.generate()
      cpf = "000.000.000-00"

      params = %{
        name: name,
        email: email,
        email_confirmation: email,
        password: password,
        cpf: cpf
      }

      {:ok, created_account} = Accounts.create_account(params)

      {:ok, account} = Accounts.get_account(created_account.id)

      assert account.name == name
      assert account.email == email
      assert account.cpf == cpf
    end

    test "yields error when id is invalid" do
      {:error, :invalid_info} = Accounts.get_account("invalid id")
    end

    test "yields error when account doesn't exist" do
      assert {:error, :not_found} = Accounts.get_account(Ecto.UUID.generate())
    end
  end

  describe "dele_account/1" do
    test "removes the correct account when input is valid" do
      name = Ecto.UUID.generate()
      email = "#{Ecto.UUID.generate()}@test.com"
      password = Ecto.UUID.generate()
      cpf = "000.000.000-11"

      params = %{
        name: name,
        email: email,
        email_confirmation: email,
        password: password,
        cpf: cpf
      }

      {:ok, account} = Accounts.create_account(params)

      {:ok, deleted_account} = Accounts.delete_account(account.id)

      assert deleted_account.name == name
      assert deleted_account.email == email
      assert deleted_account.cpf == cpf
    end

    test "yields error when id is invalid" do
      {:error, :invalid_info} = Accounts.delete_account("invalid id")
    end

    test "yields error when account doesn't exist" do
      assert {:error, :not_found} = Accounts.delete_account(Ecto.UUID.generate())
    end
  end
end
