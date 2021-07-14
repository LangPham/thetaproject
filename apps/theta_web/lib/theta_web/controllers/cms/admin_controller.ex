defmodule ThetaWeb.CMS.AdminController do
  use ThetaWeb, :controller

  #plug :require_existing_author
  #plug :authorize_article when action in [:edit, :update, :delete]

  def index(conn, _params) do
#    IO.inspect("ThetaWeb.CMS.AdminController =======================")
    IO.inspect(conn.secret_key_base)
    render(conn, "index.html")
  end


#  defp require_existing_author(conn, _) do
#      user = conn.assigns.current_user
#      user = Repo.preload(user, :author)
#      author = CMS.ensure_author_exists(user)
#      assign(conn, :current_author, author)
#  end
end
