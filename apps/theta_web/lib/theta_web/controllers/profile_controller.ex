defmodule ThetaWeb.ProfileController do
  use ThetaWeb, :controller


  def index(conn, _params) do
    IO.inspect conn, label: "ThetaWeb.ProfileController =====\n"
    render(conn, "index.html")
  end

end
