defmodule Theta.CMS.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
  #, always_change: true
end
defmodule Theta.CMS.Taxonomy do
  use Ecto.Schema
  import Ecto.Changeset

  alias Theta.CMS.Term
  alias Theta.CMS.TitleSlug
  schema "taxonomy" do
    field :title, :string
    field :slug, TitleSlug.Type
    has_many :term, Term

    timestamps()
  end

  @doc false
  def changeset(taxonomy, attrs) do
    taxonomy
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> TitleSlug.maybe_generate_slug
    |> TitleSlug.unique_constraint
  end
end
