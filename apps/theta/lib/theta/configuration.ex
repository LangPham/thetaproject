defmodule Theta.Configuration do
  @moduledoc """
  The Configuration context.
  """

  import Ecto.Query, warn: false
  alias Theta.Repo

  alias Theta.Configuration.Config

  @doc """
  Returns the list of config.

  ## Examples

      iex> list_config()
      [%Config{}, ...]

  """
  def list_config do
    case Theta.CacheDB.get("config") do
      {:ok, var} ->
        var

      {:error, _} ->
        list = Repo.all(Config)
        Theta.CacheDB.set("config", list)
        list
    end
  end

  @doc """
  Gets a single config.

  Raises `Ecto.NoResultsError` if the Config does not exist.

  ## Examples

      iex> get_config!(123)
      %Config{}

      iex> get_config!(456)
      ** (Ecto.NoResultsError)

  """
  def get_config!(id), do: Repo.get!(Config, id)

  def get_config_by_key(key) do
    var = Theta.Configuration.list_config()
    config_list = Enum.filter(var, fn x -> x.key == key end)
    config = Enum.at(config_list, 0)

    case config do
      nil -> ""
      conf -> conf.value
    end
  end

  @doc """
  Creates a config.

  ## Examples

      iex> create_config(%{field: value})
      {:ok, %Config{}}

      iex> create_config(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_config(attrs \\ %{}) do
    %Config{}
    |> Config.changeset(attrs)
    |> Repo.insert()
    |> update_cache("config")
  end

  @doc """
  Updates a config.

  ## Examples

      iex> update_config(config, %{field: new_value})
      {:ok, %Config{}}

      iex> update_config(config, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_config(%Config{} = config, attrs) do
    config
    |> Config.changeset(attrs)
    |> Repo.update()
    |> update_cache("config")
  end

  @doc """
  Deletes a config.

  ## Examples

      iex> delete_config(config)
      {:ok, %Config{}}

      iex> delete_config(config)
      {:error, %Ecto.Changeset{}}

  """
  def delete_config(%Config{} = config) do
    config
    |> Repo.delete()
    |> update_cache("config")
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking config changes.

  ## Examples

      iex> change_config(config)
      %Ecto.Changeset{source: %Config{}}

  """
  def change_config(%Config{} = config) do
    Config.changeset(config, %{})
  end

  defp update_cache(result, key) do
    case result do
      {:ok, _} ->
        Theta.CacheDB.delete(key)
        result

      {_, _} ->
        result
    end
  end
end
