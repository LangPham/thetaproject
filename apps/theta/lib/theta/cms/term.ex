defmodule Theta.CMS.Term do
  use Ecto.Schema
  import Ecto.Changeset

  alias Theta.CMS.{Taxonomy, Article}
  alias Theta.PV.PathAlias
  alias Theta.Repo

  @primary_key {:id, :string, []}
  schema "term" do
    field :name, :string
    field :description, :string
    belongs_to :taxonomy, Taxonomy, type: :string
#    belongs_to :path_alias, PathAlias
    has_many :article, Article, foreign_key: :menu_id

    timestamps()
  end

  @doc false
  def changeset(term, attrs) do
    term
    |> cast(attrs, [:name, :taxonomy_id, :description])
    |> validate_required([:name, :taxonomy_id])
    |> put_slug_id(attrs)

  end

  defp put_slug_id(%Ecto.Changeset{valid?: true,changes: %{name: name }} = changeset ,attrs) do
    case changeset.data.id do
      nil -> change(changeset, id: Slug.slugify(String.downcase(name)))
      _ -> changeset
    end
  end
  defp put_slug_id(changeset ,_), do: changeset
end
