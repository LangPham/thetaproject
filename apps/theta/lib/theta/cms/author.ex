defmodule Theta.CMS.Author do
  use Ecto.Schema
  import Ecto.Changeset

  alias Theta.CMS.Article

  schema "author" do
    field :role, :string
    belongs_to :user, Theta.Account.User
    has_many :article, Article

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:role])
    |> validate_required([:role])
    |> unique_constraint(:user_id)
  end
end
