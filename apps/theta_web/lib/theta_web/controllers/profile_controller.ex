defmodule ThetaWeb.ProfileController do
  use ThetaWeb, :controller

#  alias Theta.Account
#  alias Theta.Account.User

  def index(conn, _params) do
#    IO.inspect conn
#    user = Guardian.Plug.current_resource(conn)
#    IO.inspect user
#    user = Account.list_user()
    render(conn, "index.html")
  end

end
