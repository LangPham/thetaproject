defmodule ThetaWeb.SitemapController do
  use ThetaWeb, :controller

  alias Theta.Account
  alias Theta.Account.User
  alias ThetaWeb.Page

  def index(conn, _params) do
    page = Page.new(conn)
    IO.inspect page
    conn
    |> put_resp_content_type("application/xml")
    |> render( "index.xml", page: page)

  end

end
