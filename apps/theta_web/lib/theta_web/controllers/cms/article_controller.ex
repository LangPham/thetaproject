defmodule ThetaWeb.CMS.ArticleController do
  use ThetaWeb, :controller

  alias Theta.{CMS, Repo, CacheDB}
  alias Theta.CMS.Article


  #  plug :authorize_article when action in [:show, :edit, :update, :delete]

  def index(conn, _params) do

    article =
      CMS.list_article()
      |> Enum.sort_by(&(&1.updated_at), :desc)

    render(conn, "index.html", article: article)
  end

  def new(conn, _params) do
    menu = CMS.list_term_menu()
    serial = CMS.list_serial()
    changeset = CMS.change_article(%Article{})
    render(conn, "new.html", changeset: changeset, menu: menu, serial: serial)
  end

  def create(conn, %{"article" => article_params}) do

    #    case CMS.create_article("conn.assigns.current_author", article_params) do
    case CMS.create_article(article_params) do
      {:ok, article} ->
        article = Repo.preload(article, :menu)

        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: Routes.article_path(conn, :show, article))

      {:error, %Ecto.Changeset{} = changeset} ->

        menu = CMS.list_term_menu()
        serial = CMS.list_serial()
        render(conn, "new.html", changeset: changeset, menu: menu, serial: serial)
    end
  end

  def show(conn, %{"id" => id}) do
    IO.inspect conn, label: "SHOW COON"
    article = CMS.get_article!(id)
    render(conn, "show.html", article: article)
  end

  def edit(conn, %{"id" => id}) do
    menu = CMS.list_term_menu()
    serial = CMS.list_serial()
    article = CMS.get_article!(id)
    changeset = CMS.change_article(article)
    #    IO.inspect article, label: "ARTICLE ==========\n"
    render(conn, "edit.html", changeset: changeset, menu: menu, serial: serial, article: article)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = CMS.get_article!(id)
    case CMS.update_article(article, article_params) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: Routes.article_path(conn, :show, article))

      {:error, %Ecto.Changeset{} = changeset} ->
        menu = CMS.list_term_menu()
        serial = CMS.list_serial()
        render(conn, "edit.html", changeset: changeset, menu: menu, serial: serial)
    end
  end


  def delete(conn, %{"id" => id}) do
    article = CMS.get_article!(id)
    {:ok, _article} = CMS.delete_article(article)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: Routes.article_path(conn, :index))
  end


  #  defp require_existing_author(conn, _) do

  #    user = Guardian.Plug.current_resource(conn)
  #    user = Repo.preload(user, :author)
  #    author = CMS.ensure_author_exists(user)
  #    assign(conn, :current_author, author)
  #  end
  #

  # Todo: delete
  def abac(id) do
    article = CMS.get_article!(id)
    article.user_id
  end

end
