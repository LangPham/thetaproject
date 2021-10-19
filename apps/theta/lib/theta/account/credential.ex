defmodule Theta.Account.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  alias Theta.Account.User

  schema "credential" do
    field :email, :string
    field :password, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 8)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = credential
       ) do
    change(credential, password: Cap.hash_pwd(password))
  end

  defp put_password_hash(credential), do: credential
end
