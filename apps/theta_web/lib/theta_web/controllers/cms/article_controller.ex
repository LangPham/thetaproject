defmodule ThetaWeb.CMS.ArticleController do
  use ThetaWeb, :controller

  alias Theta.{CMS, Repo, CacheDB}
  alias Theta.CMS.Article

  #  plug :require_existing_author
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

    case CMS.create_article(conn.assigns.current_author, article_params) do
      {:ok, article} ->
        article = Repo.preload(article, :menu)
        # CacheDB
        CacheDB.delete("menu-id-#{article.menu.path_alias_id}")
        CacheDB.delete("home")
        if article.serial_id != nil, do: CacheDB.delete("serial-id-#{article.serial_id}")
        if length(article.tag) > 0 do
          for tag <- article.tag do
            CacheDB.delete("tag-#{tag.slug}")
          end
        end
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
    IO.inspect article, label: "ARTICLE ==========\n"
    render(conn, "edit.html", changeset: changeset, menu: menu, serial: serial, article: article)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article_old = CMS.get_article!(id)


    case CMS.update_article(article_old, article_params) do
      {:ok, article} ->

        article = Repo.preload(article, :menu)
        CacheDB.delete("menu-id-#{article.menu.path_alias_id}")
        CacheDB.delete("home")
        change_path = Ecto.Changeset.change article.path_alias, updated_at: article.updated_at
        Repo.update(change_path)

        tag_add = article.tag -- article_old.tag
        tag_remove = article_old.tag -- article.tag
        tag_change = tag_add ++ tag_remove

        if length(tag_change) > 0 do
          for tag <- tag_change do
            CacheDB.delete("tag-#{tag.slug}")
          end
        end
        #PV.update_path_alias(article.path_alias, %{update_at: article.updated_at})
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
    article.author_id
  end

end
