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
end
