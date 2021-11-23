defmodule ThetaWeb.Api.DataController do
  use ThetaWeb, :controller

  alias Theta.{CacheDB}

  import Ecto.Query, warn: false

  def show(conn, %{"slug" => slug}) do
    param_am =
      String.split(slug, ".")
      |> List.first()
      |> String.split("-")

    map =
      Regex.named_captures(~r/(?<menu_id>[[:print:]]+)@(?<article_id>[[:print:]]+).json/, slug)

    article = Theta.CMS.get_article!(map["article_id"])
    serial_id = article.serial_id || article.id
    serial_all = Theta.CMS.get_article_serial!(serial_id)

    serial =
      if length(serial_all) < 2 do
        []
      else
        serial_all
      end

    list_article = Theta.CMS.list_article_menu(article.menu_id)
    list_serial = for article <- serial_all, do: article.id
    new_exclude_serial = for article <- list_article, article.id not in list_serial, do: article
    new = Enum.take(new_exclude_serial, 5)
    root_url = Application.get_env(:theta_web, :root_url)
    serial = Enum.map(serial, fn a -> %{title: a.title, url: "#{root_url}/#{a.slug}"} end)
    new = Enum.map(new, fn a -> %{title: a.title, url: "#{root_url}/#{a.slug}"} end)
    pages = %{new: new, serial: serial}

    render(conn, "show.json", pages: pages)
  end
end
