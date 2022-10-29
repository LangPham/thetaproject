defmodule Theta.PV do
  @moduledoc """
  The PV context.
  """

  import Ecto.Query, warn: false
  alias Theta.Repo
  alias Theta.PV.PathError

  def get_path_error_by_path(path) do
    Repo.get_by(PathError, path: path)
  end

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
