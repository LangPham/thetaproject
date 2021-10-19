defmodule ThetaWeb.PV.PathErrorController do
  use ThetaWeb, :controller
  alias Theta.PV

  def index(conn, _params) do
    path = PV.list_path_error()
    render(conn, "index.html", paths: path)
  end

  def create(conn, %{"path_alias" => path_alias_params}) do
    case PV.create_path_alias(path_alias_params) do
      {:ok, path_alias} ->
        conn
        |> put_flash(:info, "Path alias created successfully.")
        |> redirect(to: Routes.path_alias_path(conn, :show, path_alias))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    path = PV.get_path_error!(id)
    render(conn, "show.html", path: path)
  end

  def edit(conn, %{"id" => id}) do
    path = PV.get_path_error!(id)
    changeset = PV.change_path_error(path)
    render(conn, "edit.html", path: path, changeset: changeset)
  end

  def update(conn, %{"id" => id, "path_error" => path_error_params}) do
    path_alias = PV.get_path_error!(id)

    case PV.update_path_error(path_alias, path_error_params) do
      {:ok, _path_alias} ->
        conn
        |> put_flash(:info, "Path alias updated successfully.")
        |> redirect(to: Routes.path_alias_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        path_all = PV.list_path_alias()

        render(conn, "edit_error.html",
          path_alias: path_alias,
          changeset: changeset,
          serial: path_all
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    path_alias = PV.get_path_error!(id)
    {:ok, _path_alias} = PV.delete_path_error(path_alias)

    conn
    |> put_flash(:info, "Path error deleted successfully.")
    |> redirect(to: Routes.path_alias_path(conn, :index))
  end
end
