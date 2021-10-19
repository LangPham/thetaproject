defmodule ThetaWeb.MediaController do
  use ThetaWeb, :controller

  use ThetaMedia

  def index(conn, _params) do
    base = Base.new()
    dir = Dir.ls(base)
    render(conn, "index.html", dir: dir)
  end
end
