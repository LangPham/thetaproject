defmodule Theta.CMS.Article do
  use Ecto.Schema
  import Ecto.Changeset

  import Ecto.Query, warn: false

  alias Theta.CMS.{Author, Term, Article}
  alias Theta.PV.PathAlias
  alias Theta.Repo

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
    article
    |> cast(attrs, [:title, :summary, :body, :menu_id, :photo, :is_serial, :serial_id])
    |> validate_required([:title, :summary, :body, :menu_id, :is_serial, :photo])
    |> put_slug_id(attrs)
    |> put_tags(attrs)
  end

  defp put_slug_id(
         %Ecto.Changeset{
           valid?: true,
           changes: %{
             title: title
           }
         } = changeset,
         attrs
       ) do
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

  defp put_tags(%Ecto.Changeset{valid?: true} = struct, attrs) when attrs != %{} do
    tags = attrs["tags"]
    list_tag = String.split(tags, [","], trim: true)
    list_id = Enum.map(list_tag, fn tag -> create_tag(tag) end)
    list_path_query = check_list_tag(list_id)
    Ecto.Changeset.put_assoc(struct, :tag,  list_path_query)
  end

  defp put_tags(struct, _attrs), do: struct

  defp check_list_tag(tags) do
    query = from u in Term, where: u.id in ^tags
    Repo.all(query)
  end

  defp create_tag(tag) do
    if Regex.match?(~r/@create/, tag) do
      map = Regex.named_captures(~r/(?<name>[[:print:]]+)#(?<id>[[:print:]]+)@/u, tag)
      Repo.insert(%Term{id: map["id"], name: map["name"], taxonomy_id: "tag"})
      map["id"]
    else
      map = Regex.named_captures(~r/(?<name>[[:print:]]+)#(?<id>[[:print:]]+)/u, tag)
      map["id"]
    end
  end
end
