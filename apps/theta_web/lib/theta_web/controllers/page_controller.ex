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
    render(conn, "policy.html", page: page)
  end

  def google_search(conn, _params) do
    page = Page.new(conn)
    render(conn, "google_search.html", page: page)
  end

  def index(conn, _params) do

    page = Page.new(conn)
    list_article =
      case CacheDB.get("home") do
        {:ok, var} -> var
        {:error, _} ->
          var = CMS.list_article_index()
          CacheDB.set("home", var)
          var
      end
    serial_of_menu =
      for art <- list_article, art.is_serial do
        %{title: art.title, id: art.id, slug: art.path_alias.slug}
      end
    page = put_in(page.head.ld_json, %{index: "index"})
    page = Map.put(page, :body, %{list_article: list_article, serial_menu: serial_of_menu})

    conn
    |> render("index.html", page: page)
  end

  def show(conn, %{"slug" => slug}) do
    list = conn.path_info
    tags =
      if "tag" in list do
        "tags"
      else
        nil
      end
    path = PV.get_path_alias_slug!(slug, tags)
    if path == nil do
      ThetaWeb.PV.PathAliasController.router_path_error(conn, conn.request_path)
    else
      render_content(conn, path)
    end
  end

  defp render_content(conn, %PathAlias{type_model: type_model} = path) when type_model == "article" do
    page = Page.new(conn)
    var =
      case CacheDB.get("path-alias-#{path.id}", path.updated_at) do
        {:ok, var} ->
          var
        {:error, _} ->
          var = Repo.preload(
            path,
            [
              term: [],
              article: [
                menu: [:path_alias],
                tag: [],
                author: [:user],
                serial: []
              ]
            ]
          )
          CacheDB.set("path-alias-#{path.id}", var)
          var
      end

    cache_serial =
      case {var.article.is_serial, var.article.serial_id} do
        {true, _} ->
          case CacheDB.get("serial-id-#{var.article.id}") do
            {:ok, serial} -> serial
            {:error, _} ->
              serial =
                CMS.get_serial(var.article.id)
              CacheDB.set("serial-id-#{var.article.id}", serial)
              serial
          end
        {false, id} when is_number(id) ->
          case CacheDB.get("serial-id-#{id}") do
            {:ok, serial} -> serial
            {:error, _} ->
              serial =
                CMS.get_serial(id)
              CacheDB.set("serial-id-#{id}", serial)
              serial
          end
        {_, _} -> []
      end

    page = put_in(page.head.title, var.article.title)
    page = put_in(page.head.img_article, var.article.photo)
    page = put_in(page.head.description, var.article.summary)
    page = put_in(page.head.canonical, page.head.base <> "/" <> path.slug)
    page = put_in(
      page.head.og,
      [
        %{property: "og:image:secure_url", content: page.head.base <> var.article.photo},
        %{property: "og:image", content: page.head.base <> var.article.photo},
        %{property: "og:type", content: "article"}
      ]
    )

    menu =
      case CacheDB.get("menu-id-#{var.article.menu_id}") do
        {:ok, menu} -> menu
        {:error, _} ->
          article_query =
            from a in Article,
                 order_by: [
                   desc: a.inserted_at
                 ]
          menu = Repo.preload(
            path,
            [
              article: [
                menu: [
                  article: {article_query, [author: [:user], path_alias: []]}
                ]
              ]
            ]
          )

          CacheDB.set("menu-id-#{var.article.menu_id}", menu.article.menu)
          menu.article.menu
      end

    list_serial = for article <- cache_serial, article.id != var.article.id, do: article.id
    new_exclude_article = for article <- menu.article, article.id != var.article.id, do: article
    new_exclude_serial = for article <- new_exclude_article, article.id not in list_serial, do: article
    new = Enum.take(new_exclude_serial, 5)

    page = Map.put(page, :body, %{article: var.article, serial: cache_serial, new: new})
    conn
    |> render("article.html", page: page)
  end

  defp render_content(conn, %PathAlias{type_model: type_model} = path) when type_model == "main_menu" do
    page = Page.new(conn)
    get_term = Repo.preload(path, :term)

    var =
      case CacheDB.get("menu-id-#{get_term.term.id}") do
        {:ok, var} -> var
        {:error, _} ->
          article_query =
            from a in Article,
                 order_by: [
                   desc: a.inserted_at
                 ]
          var = Repo.preload(
            path,
            [
              term: [
                article: {article_query, [author: [:user], path_alias: []]}
              ]
            ]
          )
          CacheDB.set("menu-id-#{get_term.term.id}", var.term)
          var.term
      end

    serial_of_menu =
      for art <- var.article, art.is_serial do
        %{title: art.title, id: art.id, slug: art.path_alias.slug}
      end

    des = Theta.Configuration.get_config_by_key(path.slug)



    page = put_in(page.head.title, var.title)
    page = put_in(page.head.description, des)
    page = put_in(page.head.canonical, page.head.base <> "/" <> path.slug)
    page = Map.put(page, :body, %{list_article: var.article, serial_menu: serial_of_menu})
    conn
    |> render("main_menu.html", page: page)
  end

  defp render_content(conn, %PathAlias{type_model: type_model} = path) when type_model == "tags" do
    page = Page.new(conn)

    list_qa = CMS.list_qa_by_tag(path.slug)

    IO.inspect list_qa, label: " ==================\n"
    var =
      case CacheDB.get("tag-#{path.slug}") do
        {:ok, var} -> var
        {:error, _} ->
          article_query =
            from a in Article,
                 order_by: [
                   desc: a.inserted_at
                 ]

          var = Repo.preload(
            path,
            [
              art: {article_query, [author: [:user], path_alias: []]}
            ]
          )
          CacheDB.set("tag-#{path.slug}", var)
          var
      end
    all_tag = PV.list_path_tag()
    page = put_in(page.head.title, var.slug)
    page = put_in(page.head.description, var.slug)
    page = put_in(page.head.canonical, page.head.base <> "/" <> "tag/" <> path.slug)
    page = Map.put(page, :body, %{list_article: var.art, all_tag: all_tag, list_qa: list_qa})

    conn
    |> render("tag.html", page: page)
  end

  defp render_content(conn, %PathAlias{} = _path) do
    conn
    |> render("index.html")
  end
end
