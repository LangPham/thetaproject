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
    field :is_serial, :boolean, default: false
    belongs_to :serial, Article
    has_many :section, Article, foreign_key: :serial_id

    belongs_to :author, Author
    belongs_to :menu, Term
    belongs_to :path_alias, PathAlias
    many_to_many(
      :tag,
      PathAlias,
      join_through: "article_tag",
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    Repo.preload(article, [:tag])
    |> cast(attrs, [:title, :summary, :body, :menu_id, :photo, :is_serial, :serial_id])
    |> validate_required([:title, :summary, :body, :menu_id, :is_serial, :photo])
    |> put_path_alias(attrs)
    |> validate_required([:path_alias_id])
    |> put_tags(attrs)
  end

  defp put_path_alias(%Ecto.Changeset{valid?: true} = struct, attrs) do
    if attrs["action"] == "create" do
      type_model = "article"
      slug = attrs["title"]
      attrs_path = %{slug: slug, type_model: type_model}
      path_alias =
        %PathAlias{}
        |> PathAlias.changeset(attrs_path)
        |> Repo.insert!()
      change(struct, path_alias_id: path_alias.id)
    else
      if Map.has_key?(struct.changes, :title) do
        attrs_path = %{slug: struct.changes.title, type_model: "article"}
        path_alias = Repo.get(PathAlias, struct.data.path_alias_id)
        path_alias
        |> PathAlias.changeset(attrs_path)
        |> Repo.update!()
        change(struct, path_alias_id: path_alias.id)
      else
        struct
      end
    end
  end

  defp put_path_alias(struct, _attrs), do: struct

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
