defmodule ThetaWeb.CMS.AdminController do
  use ThetaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
