defmodule Theta.CMS.Article do
  use Ecto.Schema
  import Ecto.Changeset

  import Ecto.Query, warn: false

  alias Theta.CMS.{Author, Term, Article}
  alias Theta.PV.PathAlias
  alias Theta.Repo

  # Todo: add belongs_to :serial, Article
  schema "article" do
    field :body, :string
    field :summary, :string
    field :title, :string
    field :photo, :string
    field :slug, :string
    field :is_serial, :boolean, default: false
    belongs_to :serial, Article
    has_many :section, Article, foreign_key: :serial_id

    belongs_to :author, Author
    belongs_to :menu, Term, type: :string
        many_to_many(
          :tag,
          Term,
          join_through: "article_tag",
          on_replace: :delete
        )

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    #    Repo.preload(article, [:tag])
    article
    |> cast(attrs, [:title, :summary, :body, :menu_id, :photo, :is_serial, :serial_id])
    |> validate_required([:title, :summary, :body, :menu_id, :is_serial, :photo])
    #    |> put_path_alias(attrs)
    #    |> validate_required([:path_alias_id])
    #    |> put_tags(attrs)
  end
  defp put_slug_id(%Ecto.Changeset{valid?: true,changes: %{ title: title } } = changeset, attrs ) do
    case changeset.data.id do
      nil ->
        navDT =
          NaiveDateTime.local_now()
          |> NaiveDateTime.to_string
          |> Slug.slugify(truncate: 14, separator: "")
        slug = Slug.slugify(String.downcase(title)) <> "-#{navDT}.html"
        change(changeset, slug: slug)
      _ -> changeset
    end
  end
  defp put_slug_id(changeset, _), do: changeset

  defp put_tags(%Ecto.Changeset{valid?: true} = struct, attrs) when attrs == %{} do
    struct
  end

  defp put_tags(%Ecto.Changeset{valid?: true} = struct, attrs) when attrs != %{} do
    tags = attrs["tags"]
    list_tags = for x <- String.split(tags, [" ", ","], trim: true), do: Slug.slugify(x, separator: "-")
    list_path_query = check_list_tag(list_tags)
    Ecto.Changeset.put_assoc(struct, :tag, list_path_query)
  end

  defp put_tags(struct, _attrs), do: struct

  defp check_list_tag(tags) do
    query = from t in "path_alias", where: t.type_model != "article", select: t.slug
    list_query_path = [nil | Repo.all(query)]
    list_not_exit = tags -- list_query_path
    if length(list_not_exit) > 0 do
      create_tag(list_not_exit)
    end
    query = from u in PathAlias, where: u.slug in ^tags
    Repo.all(query)
  end

  defp create_tag(tags) do
    for x <- tags do
      Repo.insert(%PathAlias{slug: x, type_model: "tags"})
    end
  end
end
