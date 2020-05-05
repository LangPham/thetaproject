defmodule Theta.PV.PathAlias do
  use Ecto.Schema
  import Ecto.Changeset

  schema "path_alias" do
    field :slug, :string
    field :type_model, :string
    has_one :term, Theta.CMS.Term
    has_one :article, Theta.CMS.Article
    many_to_many(
      :art,
      Theta.CMS.Article,
      join_through: "article_tag",
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(path_alias, attrs) do

    path_alias
    |> cast(attrs, [:slug, :type_model, :updated_at])
    |> validate_required([:slug, :type_model])
    |> put_slug_time()
    |> unique_constraint(:slug)

  end

  defp put_slug_time(
         %Ecto.Changeset{
           valid?: true,
           changes: %{
             slug: _slug
           }
         } = path_alias
       ) do
    change(path_alias, slug: create_slug(path_alias))
  end

  defp put_slug_time(path_alias), do: path_alias
  defp create_slug(changeset) do
    change = changeset.changes
    type_model =
      if Map.has_key?(change, :type_model) do
        change.type_model
      else
        changeset.data.type_model
      end
    if type_model == "article" do
      navDT = NaiveDateTime.add(NaiveDateTime.utc_now, 7 * 3600)
      Slug.slugify(changeset.changes.slug) <> "-" <> Slug.slugify(
                                                       NaiveDateTime.to_string(navDT),
                                                       truncate: 14,
                                                       separator: ""
                                                     ) <> ".html"
    else
      Slug.slugify(changeset.changes.slug)
    end

  end
end

