defmodule ThetaWeb.SitemapController do
  use ThetaWeb, :controller

  alias ThetaWeb.Page

  def index(conn, _params) do
    page = Page.new(conn)
    menu = Theta.CMS.list_term_menu()
    tag = Theta.CMS.list_tag()
    article = Theta.CMS.list_article()
    conn
    |> put_resp_content_type("application/xml")
    |> render( "index.xml", page: page, menu: menu, tag: tag, article: article)

  end

end
