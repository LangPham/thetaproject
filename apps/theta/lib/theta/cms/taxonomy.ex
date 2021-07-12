defmodule Theta.CMS.Taxonomy do
  use Ecto.Schema
  import Ecto.Changeset

  alias Theta.CMS.Term
  alias Theta.CMS.TitleSlug

  @primary_key {:id, :string, []}
  schema "taxonomy" do
    field :name, :string
    has_many :term, Term

    timestamps()
  end

  @doc false
  def changeset(taxonomy, attrs) do
    taxonomy
    |> cast(attrs, [:name])
    |> put_slug_id(attrs)
    |> validate_required([:name])
  end

  defp put_slug_id(%Ecto.Changeset{valid?: true,changes: %{name: name }} = changeset ,attrs) do
    case changeset.data.id do
      nil -> change(changeset, id: Slug.slugify(String.downcase(name)))
      _ -> changeset
    end
  end
  defp put_slug_id(changeset ,_), do: changeset

end
