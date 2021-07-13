defmodule Theta.CMS.ArticleTag do
  use Ecto.Schema
  import Ecto.Changeset

  alias Theta.CMS.{Article, Term}


  @already_exists "ALREADY_EXISTS"

  @primary_key false
  schema "article_tag" do
    belongs_to(:article, Article, primary_key: true)
    belongs_to(:term, Term, primary_key: true, type: :string)

  end

  @required_fields ~w(art_tag_id tag_id)a
  def changeset(article_tag, params \\ %{}) do
    article_tag
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:art_tag_id)
    |> foreign_key_constraint(:term_id)
    |> unique_constraint([:article, :tag],
         name: :art_tag_id_id_term_id_unique_index,
         message: @already_exists
       )
  end
end
