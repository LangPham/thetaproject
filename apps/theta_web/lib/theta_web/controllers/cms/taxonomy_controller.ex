defmodule ThetaWeb.CMS.TaxonomyController do
  use ThetaWeb, :controller

  alias Theta.CMS
  alias Theta.CMS.Taxonomy

  def index(conn, _params) do
    taxonomy = CMS.list_taxonomy()
    render(conn, "index.html", taxonomy: taxonomy)
  end

  def new(conn, _params) do
    changeset = CMS.change_taxonomy(%Taxonomy{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"taxonomy" => taxonomy_params}) do
    case CMS.create_taxonomy(taxonomy_params) do
      {:ok, taxonomy} ->
        conn
        |> put_flash(:info, "Taxonomy created successfully.")
        |> redirect(to: Routes.taxonomy_path(conn, :show, taxonomy))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    taxonomy = CMS.get_taxonomy!(id)
    render(conn, "show.html", taxonomy: taxonomy)
  end

  def edit(conn, %{"id" => id}) do
    taxonomy = CMS.get_taxonomy!(id)
    changeset = CMS.change_taxonomy(taxonomy)
    render(conn, "edit.html", taxonomy: taxonomy, changeset: changeset)
  end

  def update(conn, %{"id" => id, "taxonomy" => taxonomy_params}) do
    taxonomy = CMS.get_taxonomy!(id)

    case CMS.update_taxonomy(taxonomy, taxonomy_params) do
      {:ok, taxonomy} ->
        conn
        |> put_flash(:info, "Taxonomy updated successfully.")
        |> redirect(to: Routes.taxonomy_path(conn, :show, taxonomy))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", taxonomy: taxonomy, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    taxonomy = CMS.get_taxonomy!(id)
    {:ok, _taxonomy} = CMS.delete_taxonomy(taxonomy)

    conn
    |> put_flash(:info, "Taxonomy deleted successfully.")
    |> redirect(to: Routes.taxonomy_path(conn, :index))
  end
end
