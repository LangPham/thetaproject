defmodule ThetaWeb.PageController do
  use ThetaWeb, :controller

  import Ecto.Query, warn: false

  alias Theta.{PV, Repo, CacheDB, CMS}
  alias Theta.PV.PathAlias
  alias Theta.CMS.Article
  alias ThetaWeb.Page
  plug :put_layout, "layout.html"

  def policy(conn, _params) do
    page = Page.new(conn)
    page = put_in(page.head.title, "Chính sách bảo mật")
    page = put_in(page.head.description, "Chính sách bảo mật, điều khoản bảo mật của Theta")
    page = put_in(page.head.canonical, page.head.base <> "/policy")
    render(conn, "policy.html", page: page)
  end

  def google_search(conn, _params) do
    page = Page.new(conn)
    page = put_in(page.head.title, "Tìm kiếm")
    page = put_in(page.head.description, "Trang tìm kiếm của Theta")
    page = put_in(page.head.canonical, page.head.base <> "/search")
    render(conn, "google_search.html", page: page)
  end

  def index(conn, _params) do

    page = Page.new(conn)
    list_article = CMS.list_article_index()

    serial_of_menu =
      for art <- list_article, art.is_serial do
        %{title: art.title, id: art.id, slug: art.slug}
      end

    page = put_in(page.head.ld_json, %{index: "index"})
    page = put_in(page.head.canonical, "")

    page = Map.put(page, :body, %{list_article: list_article, serial_menu: serial_of_menu})

    conn
    |> render("index.html", page: page)
  end

  def show(conn, %{"slug" => slug}) do

    cond do
      Regex.match?(~r/.html/, slug) -> show_article(conn, slug)
      Regex.match?(~r/.htm/, slug) -> show_tag(conn, slug)
      true -> show_menu(conn, slug)
    end
  end

  defp show_article(conn, slug) do
    page = Page.new(conn)

    article = Theta.CMS.get_article_by_slug!(slug)
    serial_id = article.serial_id || article.id
    serial_all = Theta.CMS.get_article_serial!(serial_id)
    serial =
      if length(serial_all) < 2 do
        []
      else
        serial_all
      end

    page = put_in(page.head.title, article.title)
    page = put_in(page.head.img_article, article.photo)
    page = put_in(page.head.description, article.summary)
    page = put_in(page.head.canonical, article.slug)
    page = put_in(page.head.ld_json, %{article: "article"})
    page = put_in(
      page.head.og,
      [
        %{property: "og:image:secure_url", content: page.head.base <> article.photo},
        %{property: "og:image", content: page.head.base <> article.photo},
        %{property: "og:type", content: "article"}
      ]
    )

    list_article = Theta.CMS.list_article_menu(article.menu_id)
    list_serial = for article <- serial_all, do: article.id
    new_exclude_serial = for article <- list_article, article.id not in list_serial, do: article
    new = Enum.take(new_exclude_serial, 5)

    page = Map.put(page, :body, %{article: article, serial: serial, new: new})
    conn
    |> render("article.html", page: page)
  end

  defp show_menu(conn, slug) do
    page = Page.new(conn)

    list_article = Theta.CMS.list_article_menu(slug)

    serial_menu = Theta.CMS.list_article_serial_menu(slug)
    term = Theta.CMS.get_term!(slug)

    page = put_in(page.head.title, term.name)
    page = put_in(page.head.description, term.description)
    page = put_in(page.head.canonical, term.id)
    page = put_in(page.head.ld_json, %{main_menu: "main_menu"})
    page = Map.put(page, :body, %{list_article: list_article, serial_menu: serial_menu})
    conn
    |> render("main_menu.html", page: page)
  end

  defp show_tag(conn, slug) do
    page = Page.new(conn)
    tag = String.split(slug, ".") |> List.first
    list_article = CMS.list_article_by_tag(tag)

    term = CMS.get_term!(tag)
    all_tag = CMS.list_tag()
    list_qa = CMS.list_qa_by_tag(tag)


    page = put_in(page.head.title, term.name)
    page = put_in(page.head.description, term.description)
    page = put_in(page.head.canonical, term.id)
    page = put_in(page.head.ld_json, %{main_menu: "main_menu"})
    page = Map.put(page, :body, %{list_article: list_article, all_tag: all_tag, list_qa: list_qa})
    conn
    |> render("tag.html", page: page)
  end

end
