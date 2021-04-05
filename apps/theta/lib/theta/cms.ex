defmodule Theta.CMS do
  @moduledoc """
  The CMS context.
  """

  import Ecto.Query, warn: false

  alias Theta.{Account, PV, Repo, Upload, CacheDB}
  alias Theta.CMS.Taxonomy



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

  alias Theta.CMS.Term

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

  @doc """
  Returns the list of term for main menu

  ## Examples

      iex> list_term_menu()
      [%Term{}, ...]

  """
  def list_term_menu do
    taxonomy_id = 1
    Term
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

    attrs = Map.put_new(attrs, "action", "create")
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
    path_alias = PV.get_path_alias!(term.path_alias_id)
    Repo.delete(path_alias)

  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking term changes.

  ## Examples

      iex> change_term(term)
      %Ecto.Changeset{source: %Term{}}

  """
  def change_term(%Term{} = term) do
    Term.changeset(term, %{})
  end

  alias Theta.CMS.Author

  @doc """
  Returns the list of author.

  ## Examples

      iex> list_author()
      [%Author{}, ...]

  """
  def list_author do
    Repo.all(Author)
  end

  @doc """
  Gets a single author.

  Raises `Ecto.NoResultsError` if the Author does not exist.

  ## Examples

      iex> get_author!(123)
      %Author{}

      iex> get_author!(456)
      ** (Ecto.NoResultsError)

  """
  def get_author!(id) do
    Author
    |> Repo.get!(id)
    |> Repo.preload(user: :credential)
  end

  @doc """
  Creates a author.

  ## Examples

      iex> create_author(%{field: value})
      {:ok, %Author{}}

      iex> create_author(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_author(attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a author.

  ## Examples

      iex> update_author(author, %{field: new_value})
      {:ok, %Author{}}

      iex> update_author(author, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_author(%Author{} = author, attrs) do
    author
    |> Author.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a author.

  ## Examples

      iex> delete_author(author)
      {:ok, %Author{}}

      iex> delete_author(author)
      {:error, %Ecto.Changeset{}}

  """
  def delete_author(%Author{} = author) do
    Repo.delete(author)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking author changes.

  ## Examples

      iex> change_author(author)
      %Ecto.Changeset{source: %Author{}}

  """
  def change_author(%Author{} = author) do
    Author.changeset(author, %{})
  end

  alias Theta.CMS.Article

  @doc """
  Returns the list of article.

  ## Examples

      iex> list_article()
      [%Article{}, ...]

  """
  def list_article do
    Article
    |> Repo.all()
    |> Repo.preload(
         author: [
           user: :credential
         ]
       )
  end

  def list_article_index do
    Article
    |> order_by([c], desc: c.inserted_at)
    |> Repo.all()
    |> Repo.preload(
         [
           author: [
             user: :credential
           ],
           path_alias: []
         ]
       )
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
    |> Repo.preload(
         [
           author: [
             user: :credential
           ],
           tag: [],
           menu: [],
           path_alias: []
         ]
       )
  end


  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(%Author{} = author, attrs \\ %{}) do

    attrs = Map.put_new(attrs, "action", "create")

    %Article{}
    |> Article.changeset(attrs)
    |> Ecto.Changeset.put_change(:author_id, author.id)
    |> Repo.insert()
  end

  def ensure_author_exists(%Account.User{author: author} = user) when author == nil do
    role = if user.id == 1 do
      "root"
    else
      "user"
    end
    %Author{user_id: user.id, role: role}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.unique_constraint(:user_id)
    |> Repo.insert()
    |> handle_existing_author()
  end
  def ensure_author_exists(%Account.User{author: _author} = user), do: user.author
  defp handle_existing_author({:ok, author}), do: author


  @doc """
  Updates a article.

  ## Examples

      iex> update_article(article, %{field: new_value})
      {:ok, %Article{}}

      iex> update_article(article, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article(%Article{} = article, attrs) do
    attrs = Map.put_new(attrs, "action", "update")
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
    path_alias = PV.get_path_alias!(article.path_alias_id)
    if article.photo != nil do
      Upload.delete_file(article.photo)
    end
    article = Repo.preload(article, :menu)
    CacheDB.delete("menu-id-#{article.menu.path_alias_id}")
    CacheDB.delete("home")
    Repo.delete(path_alias)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article changes.

  ## Examples

      iex> change_article(article)
      %Ecto.Changeset{source: %Article{}}

  """
  def change_article(%Article{} = article) do
    IO.inspect article, label: "SDfsdfsdfsdfs"
    Article.changeset(article, %{})
  end

  def get_serial(id) do
    article = get_article!(id)

    serial = Repo.preload(
      article,
      [
        path_alias: [],
        section: [:path_alias]
      ]
    )
    fist = %{id: serial.id, slug: serial.path_alias.slug, title: serial.title}
    list =
      for section <- serial.section do
        %{id: section.id, slug: section.path_alias.slug, title: section.title}
      end
    list = Enum.sort_by(list, &(&1.id))
    [fist | list]
  end


  alias Theta.CMS.Qa

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
    query = from(q in Qa,
      distinct: [q.tag], select: q.tag)
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
end
