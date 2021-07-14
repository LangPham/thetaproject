defmodule Theta.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Theta.Account.Credential

  schema "user" do
    field :name, :string
    field :username, :string
    field :role, :string, default: 'USER'
    field :avatar, :string
    has_one :credential, Credential
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :role])
    |> validate_required([:name, :username])
    |> unique_constraint(:username)
  end
end
