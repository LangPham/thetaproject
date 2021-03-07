defmodule ThetaWeb.Api.DataController do
  use ThetaWeb, :controller
  alias Theta.{PV, Repo, CacheDB, CMS}
  alias Theta.PV.PathAlias
  alias Theta.CMS.Article
  alias ThetaWeb.Page
  import Ecto.Query, warn: false

  def show(conn, %{"slug" => slug}) do
    #    IO.inspect slug
    param_am =
      String.split(slug, ".")
      |> List.first()
      |> String.split("-")
    {menu_id, _} = Integer.parse(List.first(param_am))
    {article_id, _} = Integer.parse(List.last(param_am))
#    IO.inspect(article_id)
#    IO.inspect(CacheDB.get("menu-id-#{menu_id}"))

    menu =
      case CacheDB.get("menu-id-#{menu_id}") do
        {:ok, menu1} -> menu1
        {:error, _} -> []
      end
    article =
      Enum.filter(menu.article, fn x -> x.id == article_id end)
      |> List.first()

    cache_serial =
      case {article.is_serial, article.serial_id} do
        {true, _} ->
          case CacheDB.get("serial-id-#{article.id}") do
            {:ok, serial} -> serial
            {:error, _} -> []
          end
        {false, id} when is_number(id) ->
          case CacheDB.get("serial-id-#{id}") do
            {:ok, serial} -> serial
            {:error, _} -> []
          end
        {_, _} -> []
      end
    list_serial = for article1 <- cache_serial, article1.id != article.id, do: article1.id
    new_exclude_article = Enum.filter(menu.article, fn x -> x.id != article_id and x.id not in list_serial end)
    new = Enum.take(new_exclude_article, 5)

#    IO.inspect cache_serial
    serial = Enum.map(cache_serial, fn a -> %{title: a.title, url: "https://theta.vn/#{a.slug}"} end)
    new = Enum.map(new, fn a -> %{title: a.title, url: "https://theta.vn/#{a.path_alias.slug}"} end)
    pages = %{new: new, serial: serial}

    render(conn, "show.json", pages: pages)
  end
end
