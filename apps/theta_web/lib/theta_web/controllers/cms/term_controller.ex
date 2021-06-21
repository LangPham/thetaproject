defmodule ThetaWeb.CMS.TermController do
  use ThetaWeb, :controller

  alias Theta.{CMS, CacheDB}
  alias Theta.CMS.Term

  def index(conn, _params) do
    term = CMS.list_term()
    render(conn, "index.html", term: term)
  end

  def new(conn, _params) do
    taxonomy = CMS.list_taxonomy()
    changeset = CMS.change_term(%Term{})
    render(conn, "new.html", changeset: changeset, taxonomy: taxonomy)
  end

  def create(conn, %{"term" => term_params}) do
    case CMS.create_term(term_params) do
      {:ok, term} ->
        if term.taxonomy_id == 1, do: CacheDB.delete("menu-main")
        conn
        |> put_flash(:info, "Term created successfully.")
        |> redirect(to: Routes.term_path(conn, :show, term))

      {:error, %Ecto.Changeset{} = changeset} ->
        taxonomy = CMS.list_taxonomy()
        render(conn, "new.html", changeset: changeset, taxonomy: taxonomy)
    end
  end

  def show(conn, %{"id" => id}) do
#    term = CMS.get_term!(id)
#    render(conn, "show.html", term: term)
    term =
      # lấy nội dung post từ cache
      case CacheDB.get("term-#{id}") do
        # Nếu có ròi thì khỏi cần đọc DB
        {:ok, term} ->
          IO.puts("HIT TERM")
#          IO.inspect term
          term

        {:error, _} ->
          IO.puts("MISS")
          # Chưa cache thì đọc từ DB
          term = CMS.get_term!(id)

          # cache bài viết 60s
          CacheDB.set("term-#{id}", term)
          term
      end

    render(conn, "show.html", term: term)
  end



  def edit(conn, %{"id" => id}) do
    taxonomy = CMS.list_taxonomy()
    term = CMS.get_term!(id)
    changeset = CMS.change_term(term)
    render(conn, "edit.html", term: term, changeset: changeset, taxonomy: taxonomy)
  end

  def update(conn, %{"id" => id, "term" => term_params}) do
    term = CMS.get_term!(id)

    case CMS.update_term(term, term_params) do
      {:ok, term} ->
        if term.taxonomy_id == 1, do: CacheDB.delete("menu-main")
        conn
        |> put_flash(:info, "Term updated successfully.")
        |> redirect(to: Routes.term_path(conn, :show, term))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", term: term, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    term = CMS.get_term!(id)
    {:ok, _term} = CMS.delete_term(term)
    if term.taxonomy_id == 1, do: CacheDB.delete("menu-main")
    conn
    |> put_flash(:info, "Term deleted successfully.")
    |> redirect(to: Routes.term_path(conn, :index))
  end

  def abac(id) do
    term = CMS.get_term!(id)
    IO.inspect term, label: "TERM IN ABAC"

    true
  end
end
