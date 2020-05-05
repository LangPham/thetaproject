defmodule ThetaWeb.Router do
  use ThetaWeb, :router
  # Todo: enable Plug.ErrorHandler
  use Plug.ErrorHandler

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug ThetaWeb.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  #  pipeline :ensure_root do
  #    plug Guardian.Plug.EnsureAuthenticated
  #  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ThetaWeb do
    pipe_through [:browser, :auth]

    get "/login", SessionController, :new
    get "/logout", SessionController, :delete
    resources "/sessions", SessionController, only: [:new, :create, :delete], singleton: true
  end

  scope "/", ThetaWeb do
    get "/", PageController, :index
    get "/sitemap.xml", SitemapController, :index
    get "/:slug", PageController, :show
    get "/tag/:slug", PageController, :show
  end

  scope "/user", ThetaWeb do
    pipe_through [:browser, :auth, :ensure_auth]
    get "/me", ProfileController, :index
  end

  scope "/admin", ThetaWeb do
    #    pipe_through [:browser, :authenticate_user]
    pipe_through [:browser, :auth, :ensure_auth, :ensure_root]
    resources "/users", UserController
    resources "/alias-404", PV.PathAliasController
    resources "/config", ConfigController
  end

  scope "/cms", ThetaWeb.CMS, as: :cms do
    #    pipe_through [:browser, :authenticate_user]
    pipe_through [:browser, :auth, :ensure_auth, :ensure_root]
    get "/admin", AdminController, :index
    resources "/taxonomy", TaxonomyController
    resources "/term", TermController
    resources "/article", ArticleController
  end

  scope "/api", ThetaWeb.CMS do
#    pipe_through [:api, :auth, :ensure_auth, :ensure_root]
    pipe_through [:api, :auth]
    post "/upload", UploadController, :index
  end

  defp ensure_root(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    case user.role do
      "ROOT" -> conn
      _ ->
        conn
        |> Phoenix.Controller.put_flash(:error, "You don't have permission to access this resource!")
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()
    end
  end

  def handle_errors(conn, %{kind: _kind, reason: reason, stack: _stack}) do
    path_error = reason.conn.request_path
    ThetaWeb.PV.PathAliasController.router_path_error(conn, path_error)
  end
end
