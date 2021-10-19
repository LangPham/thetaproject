defmodule ThetaWeb.ConfigController do
  use ThetaWeb, :controller

  alias Theta.Configuration
  alias Theta.Configuration.Config

  def index(conn, _params) do
    config = Configuration.list_config()

    render(conn, "index.html", config: config)
  end

  def new(conn, _params) do
    changeset = Configuration.change_config(%Config{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"config" => config_params}) do
    case Configuration.create_config(config_params) do
      {:ok, config} ->
        Theta.CacheDB.delete("config")

        conn
        |> put_flash(:info, "Config created successfully.")
        |> redirect(to: Routes.config_path(conn, :show, config))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    config = Configuration.get_config!(id)
    render(conn, "show.html", config: config)
  end

  def edit(conn, %{"id" => id}) do
    config = Configuration.get_config!(id)
    changeset = Configuration.change_config(config)
    render(conn, "edit.html", config: config, changeset: changeset)
  end

  def update(conn, %{"id" => id, "config" => config_params}) do
    config = Configuration.get_config!(id)

    case Configuration.update_config(config, config_params) do
      {:ok, config} ->
        Theta.CacheDB.delete("config")

        conn
        |> put_flash(:info, "Config updated successfully.")
        |> redirect(to: Routes.config_path(conn, :show, config))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", config: config, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    config = Configuration.get_config!(id)
    {:ok, _config} = Configuration.delete_config(config)
    Theta.CacheDB.delete("config")

    conn
    |> put_flash(:info, "Config deleted successfully.")
    |> redirect(to: Routes.config_path(conn, :index))
  end
end
