defmodule Theta.CMS.Term do
  use Ecto.Schema
  import Ecto.Changeset

  alias Theta.CMS.{Taxonomy, Article}
  alias Theta.PV.PathAlias
  alias Theta.Repo

  schema "term" do
    field :title, :string
    belongs_to :taxonomy, Taxonomy
    belongs_to :path_alias, PathAlias
    has_many :article, Article, foreign_key: :menu_id

    timestamps()
  end

  @doc false
  def changeset(term, attrs) do
    term
    |> cast(attrs, [:title, :taxonomy_id])
    |> validate_required([:title, :taxonomy_id])
    |> put_path_alias(attrs)

  end

  defp put_path_alias(%Ecto.Changeset{valid?: true} = struct, attrs) do

    if attrs["action"] == "create" do
      taxonomy = Repo.get(Taxonomy, attrs["taxonomy_id"])
      type_model = taxonomy.slug
      slug = attrs["title"]
      attrs_path = %{slug: slug, type_model: type_model}
      path_alias =
        %PathAlias{}
        |> PathAlias.changeset(attrs_path)
        |> Repo.insert!()
      change(struct, path_alias_id: path_alias.id)
    else
      if struct.changes == %{} do
        struct
      else
        path_alias = Repo.get(PathAlias, struct.data.path_alias_id)

        type_model =
          if Map.has_key?(struct.changes, :taxonomy_id) do
            taxonomy = Repo.get(Taxonomy, struct.changes.taxonomy_id)
            taxonomy.slug
          else
            path_alias.type_model
          end
        slug =
          if Map.has_key?(struct.changes, :title) do
            struct.changes.title
          else
            path_alias.slug
          end
        attrs_path = %{slug: slug, type_model: type_model}

        path_alias
        |> PathAlias.changeset(attrs_path)
        |> Repo.update!()
        change(struct, path_alias_id: path_alias.id)
      end
    end
  end
  defp put_path_alias(struct, _attrs), do: struct
end
