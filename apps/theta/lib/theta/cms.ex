defmodule Theta.CMS do
  @moduledoc """
  The CMS context.
  """

  import Ecto.Query, warn: false

  alias Theta.{Account, PV, Repo, Upload}
  alias Theta.CMS.{Taxonomy, Term, Article, Qa, ArticleTag}

  @doc """
  Returns the list of taxonomy.

  ## Examples

      iex> list_taxonomy()
      [%Taxonomy{}, ...]

  """
  def list_taxonomy do
    Repo.all(Taxonomy)
  end

  @doc """
  Gets a single taxonomy.

  Raises `Ecto.NoResultsError` if the Taxonomy does not exist.

  ## Examples

      iex> get_taxonomy!(123)
      %Taxonomy{}

      iex> get_taxonomy!(456)
      ** (Ecto.NoResultsError)

  """
  def get_taxonomy!(id), do: Repo.get!(Taxonomy, id)

  @doc """
  Creates a taxonomy.

  ## Examples

      iex> create_taxonomy(%{field: value})
      {:ok, %Taxonomy{}}

      iex> create_taxonomy(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_taxonomy(attrs \\ %{}) do
    %Taxonomy{}
    |> Taxonomy.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a taxonomy.

  ## Examples

      iex> update_taxonomy(taxonomy, %{field: new_value})
      {:ok, %Taxonomy{}}

      iex> update_taxonomy(taxonomy, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_taxonomy(%Taxonomy{} = taxonomy, attrs) do
    taxonomy
    |> Taxonomy.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a taxonomy.

  ## Examples

      iex> delete_taxonomy(taxonomy)
      {:ok, %Taxonomy{}}

      iex> delete_taxonomy(taxonomy)
      {:error, %Ecto.Changeset{}}

  """
  def delete_taxonomy(%Taxonomy{} = taxonomy) do
    Repo.delete(taxonomy)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking taxonomy changes.

  ## Examples

      iex> change_taxonomy(taxonomy)
      %Ecto.Changeset{source: %Taxonomy{}}

  """
  def change_taxonomy(%Taxonomy{} = taxonomy) do
    Taxonomy.changeset(taxonomy, %{})
  end

  @doc """
  Returns the list of term.

  ## Examples

      iex> list_term()
      [%Term{}, ...]

  """
  def list_term do
    Term
    |> Repo.all()
    |> Repo.preload(:taxonomy)
  end

  def list_tag do
    Term
    |> where([t], t.taxonomy_id == "tag")
    |> Repo.all()
  end

  @doc """
  Returns the list of term for main menu

  ## Examples

      iex> list_term_menu()
      [%Term{}, ...]

  """
  def list_term_menu do
    taxonomy_id = "main-menu"

    Term
    |> order_by([t], asc: t.inserted_at)
    |> where([t], t.taxonomy_id == ^taxonomy_id)
    |> Repo.all()
  end

  @doc """
  Gets a single term.

  Raises `Ecto.NoResultsError` if the Term does not exist.

  ## Examples

      iex> get_term!(123)
      %Term{}

      iex> get_term!(456)
      ** (Ecto.NoResultsError)

  """
  def get_term!(id), do: Repo.get!(Term, id)

  @doc """
  Creates a term.

  ## Examples

      iex> create_term(%{field: value})
      {:ok, %Term{}}

      iex> create_term(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_term(attrs \\ %{}) do
    %Term{}
    |> Term.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a term.

  ## Examples

      iex> update_term(term, %{field: new_value})
      {:ok, %Term{}}

      iex> update_term(term, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_term(%Term{} = term, attrs) do
    attrs = Map.put_new(attrs, "action", "update")

    term
    |> Term.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a term.

  ## Examples

      iex> delete_term(term)
      {:ok, %Term{}}

      iex> delete_term(term)
      {:error, %Ecto.Changeset{}}

  """
  def delete_term(%Term{} = term) do
    Repo.delete(term)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking term changes.

  ## Examples

      iex> change_term(term)|> order_by([a], desc: a.inserted_at)
      %Ecto.Changeset{source: %Term{}}

  """
  def change_term(%Term{} = term) do
    Term.changeset(term, %{})
  end

  @doc """
  Returns the list of article.

  ## Examples

      iex> list_article()
      [%Article{}, ...]

  """
  def list_article do
    Article
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def list_article_menu(slug) do
    Article
    |> where([a], a.menu_id == ^slug)
    |> order_by([a], desc: a.inserted_at)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def list_article_serial_menu(slug) do
    Article
    |> where([a], a.menu_id == ^slug and a.is_serial)
    |> order_by([a], desc: a.inserted_at)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def list_article_index do
    Article
    |> order_by([c], desc: c.inserted_at)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def list_serial do
    Article
    |> where([s], s.is_serial == true)
    |> Repo.all()
  end

  @doc """
  Gets a single article.

  Raises `Ecto.NoResultsError` if the Article does not exist.

  ## Examples

      iex> get_article!(123)
      %Article{}

      iex> get_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article!(id) do
    Article
    |> Repo.get!(id)
    |> Repo.preload(:tag)
  end

  def get_article_by_slug!(slug) do
    Article
    |> Repo.get_by!(slug: slug)
    |> Repo.preload(
      user: [],
      tag: [],
      menu: []
    )
  end

  def get_article_serial!(id) do
    article_main = get_article!(id)

    article_sub =
      Article
      |> where([a], a.serial_id == ^id)
      |> order_by([a], asc: a.id)
      |> Repo.all()

    [article_main | article_sub]
  end

  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a article.

  ## Examples

      iex> update_article(article, %{field: new_value})
      {:ok, %Article{}}

      iex> update_article(article, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a article.

  ## Examples

      iex> delete_article(article)
      {:ok, %Article{}}

      iex> delete_article(article)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article changes.

  ## Examples

      iex> change_article(article)
      %Ecto.Changeset{source: %Article{}}

  """
  def change_article(%Article{} = article) do
    Article.changeset(article, %{})
  end

  def get_serial(id) do
    article = get_article!(id)

    serial =
      Repo.preload(
        article,
        path_alias: [],
        section: [:path_alias]
      )

    fist = %{id: serial.id, slug: serial.path_alias.slug, title: serial.title}

    list =
      for section <- serial.section do
        %{id: section.id, slug: section.path_alias.slug, title: section.title}
      end

    list = Enum.sort_by(list, & &1.id)
    [fist | list]
  end

  @doc """
  Returns the list of qa.

  ## Examples

      iex> list_qa()
      [%Qa{}, ...]

  """
  def list_qa do
    Repo.all(Qa)
  end

  def list_qa_by_tag(tag) do
    Qa
    |> where([q], q.tag == ^tag)
    |> Repo.all()
  end

  def list_tag_have_qa() do
    query =
      from(
        q in Qa,
        distinct: [q.tag],
        select: q.tag
      )

    Repo.all(query)
  end

  @doc """
  Gets a single qa.

  Raises `Ecto.NoResultsError` if the Qa does not exist.

  ## Examples

      iex> get_qa!(123)
      %Qa{}

      iex> get_qa!(456)
      ** (Ecto.NoResultsError)

  """
  def get_qa!(id), do: Repo.get!(Qa, id)

  @doc """
  Creates a qa.

  ## Examples

      iex> create_qa(%{field: value})
      {:ok, %Qa{}}

      iex> create_qa(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_qa(attrs \\ %{}) do
    %Qa{}
    |> Qa.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a qa.

  ## Examples

      iex> update_qa(qa, %{field: new_value})
      {:ok, %Qa{}}

      iex> update_qa(qa, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_qa(%Qa{} = qa, attrs) do
    qa
    |> Qa.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a qa.

  ## Examples

      iex> delete_qa(qa)
      {:ok, %Qa{}}

      iex> delete_qa(qa)
      {:error, %Ecto.Changeset{}}

  """
  def delete_qa(%Qa{} = qa) do
    Repo.delete(qa)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking qa changes.

  ## Examples

      iex> change_qa(qa)
      %Ecto.Changeset{data: %Qa{}}

  """
  def change_qa(%Qa{} = qa, attrs \\ %{}) do
    Qa.changeset(qa, attrs)
  end

  def list_article_by_tag(tag) do
    ArticleTag
    |> order_by([a], desc: a.article_id)
    |> where([a], a.term_id == ^tag)
    |> Repo.all()
    |> Repo.preload(
      article: [
        user: []
      ]
    )
  end
end
