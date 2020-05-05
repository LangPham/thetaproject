defmodule Theta.PV do
  @moduledoc """
  The PV context.
  """

  import Ecto.Query, warn: false
  alias Theta.Repo

  alias Theta.PV.{PathAlias, PathError}
  alias Theta.CacheDB

  @doc """
  Returns the list of path_alias.

  ## Examples

      iex> list_path_alias()
      [%PathAlias{}, ...]

  """
  def list_path_alias do
    PathAlias
    |> Repo.all()
    |> Repo.preload([:term, :article])
  end

  def list_path_main_menu do

    # lấy nội dung post từ cache
    case CacheDB.get("menu-main") do
      {:ok, menu} -> menu

      {:error, _} ->
        string = "main_menu"
        menu =
          PathAlias
          |> where([m], m.type_model == ^string)
          |> Repo.all()
          |> Repo.preload(:term)

        CacheDB.set("menu-main", menu)
        menu
    end
  end

  def list_path_tag do

    # lấy nội dung post từ cache
    case CacheDB.get("all-tag") do
      {:ok, all_tag} -> all_tag

      {:error, _} ->
        string = "tags"
        all_tag =
          PathAlias
          |> where([m], m.type_model == ^string)
          |> Repo.all()

        CacheDB.set("all-tag", all_tag)
        all_tag
    end
  end

  @doc """
  Gets a single path_alias.

  Raises `Ecto.NoResultsError` if the Path alias does not exist.

  ## Examples

      iex> get_path_alias!(123)
      %PathAlias{}

      iex> get_path_alias!(456)
      ** (Ecto.NoResultsError)

  """
  def get_path_alias!(id), do: Repo.get!(PathAlias, id)

  def get_path_alias_slug!(slug, tags) when tags == "tags" do

    #    case CacheDB.get("path-tags") do
    #      # Nếu có ròi thì khỏi cần đọc DB
    #      {:ok, path} ->
    #        IO.puts("HIT TAGS")
    #        #IO.inspect path
    #        path
    #
    #      {:error, _} ->
    #        IO.puts("MISS TAGS")
    #        # Chưa cache thì đọc từ DB
    #        path =
    #          PathAlias
    #          |> where([p], p.type_model == ^tags)
    #          |> Repo.get_by(slug: slug)
    #
    #        # cache menu mac dinh
    #        CacheDB.set("path-tags", path)
    #        path
    #    end

    PathAlias
    |> where([p], p.type_model == ^tags)
    |> Repo.get_by(slug: slug)
  end

  def get_path_alias_slug!(slug, _tags) do
    string = "tags"
    PathAlias
    |> where([p], p.type_model != ^string)
    |> Repo.get_by(slug: slug)
  end


  @doc """
  Creates a path_alias.

  ## Examples

      iex> create_path_alias(%{field: value})
      {:ok, %PathAlias{}}

      iex> create_path_alias(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_path_alias(attrs \\ %{}) do
    %PathAlias{}
    |> PathAlias.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a path_alias.

  ## Examples

      iex> update_path_alias(path_alias, %{field: new_value})
      {:ok, %PathAlias{}}

      iex> update_path_alias(path_alias, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_path_alias(%PathAlias{} = path_alias, attrs) do
    path_alias
    |> PathAlias.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a path_alias.

  ## Examples

      iex> delete_path_alias(path_alias)
      {:ok, %PathAlias{}}

      iex> delete_path_alias(path_alias)
      {:error, %Ecto.Changeset{}}

  """
  def delete_path_alias(%PathAlias{} = path_alias) do
    Repo.delete(path_alias)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking path_alias changes.

  ## Examples

      iex> change_path_alias(path_alias)
      %Ecto.Changeset{source: %PathAlias{}}

  """
  def change_path_alias(%PathAlias{} = path_alias) do
    PathAlias.changeset(path_alias, %{})
  end

  alias Theta.PV.PathError

  @doc """
  Returns the list of path_error.

  ## Examples

      iex> list_path_error()
      [%PathError{}, ...]

  """
  def list_path_error do
    PathError
    |> order_by([p], desc: p.count)
    |> Repo.all()
    |> Repo.preload(:path_alias)
  end

  @doc """
  Gets a single path_error.

  Raises `Ecto.NoResultsError` if the Path error does not exist.

  ## Examples

      iex> get_path_error!(123)
      %PathError{}

      iex> get_path_error!(456)
      ** (Ecto.NoResultsError)

  """
  def get_path_error!(id), do: Repo.get!(PathError, id)

  def get_path_error_path(path) do
    PathError
    |> Repo.get_by(path: path)
  end
  @doc """
  Creates a path_error.

  ## Examples

      iex> create_path_error(%{field: value})
      {:ok, %PathError{}}

      iex> create_path_error(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_path_error(attrs \\ %{}) do
    %PathError{}
    |> PathError.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a path_error.

  ## Examples

      iex> update_path_error(path_error, %{field: new_value})
      {:ok, %PathError{}}

      iex> update_path_error(path_error, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_path_error(%PathError{} = path_error, attrs) do
    path_error
    |> PathError.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a path_error.

  ## Examples

      iex> delete_path_error(path_error)
      {:ok, %PathError{}}

      iex> delete_path_error(path_error)
      {:error, %Ecto.Changeset{}}

  """
  def delete_path_error(%PathError{} = path_error) do
    Repo.delete(path_error)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking path_error changes.

  ## Examples

      iex> change_path_error(path_error)
      %Ecto.Changeset{source: %PathError{}}

  """
  def change_path_error(%PathError{} = path_error) do
    PathError.changeset(path_error, %{})
  end

end