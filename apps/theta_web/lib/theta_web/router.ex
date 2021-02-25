defmodule ThetaWeb.Router do
  use ThetaWeb, :router
  # Todo: enable Plug.ErrorHandler
   use Plug.ErrorHandler

  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
#    plug :fetch_flash
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :cookie_test
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
    get "/search", PageController, :google_search
    resources "/sessions", SessionController, only: [:new, :create, :delete], singleton: true
    get "/", PageController, :index
    get "/policy", PageController, :policy
    get "/sitemap.xml", SitemapController, :index
    live "/live", PageLive, layout: {ThetaWeb.LayoutView, "layoutlive.html"}
    live "/media-live", MediaLive, layout: {ThetaWeb.LayoutView, "layoutlive.html"}
    get "/media", MediaController, :index
    get "/:slug", PageController, :show
    get "/tag/:slug", PageController, :show

  end

  scope "/auth", ThetaWeb do
    pipe_through :browser
    get "/:provider", OauthController, :index
    get "/:provider/callback", OauthController, :callback
#    delete "/logout", OauthController, :delete

  end

  scope "/user", ThetaWeb do
    pipe_through [:browser, :auth, :ensure_auth]
    get "/me", ProfileController, :index
  end

  scope "/admin", ThetaWeb do
    pipe_through [:browser, :auth, :ensure_auth, :ensure_root]
    resources "/users", UserController
    resources "/alias-404", PV.PathAliasController
    resources "/config", ConfigController
    get "/index", CMS.AdminController, :index
    resources "/taxonomy", CMS.TaxonomyController
    resources "/term", CMS.TermController
    resources "/article", CMS.ArticleController
    resources "/qa", CMS.QaController
    live_dashboard "/dashboard", metrics: ThetaWeb.Telemetry
  end

#  scope "/cms", ThetaWeb.CMS, as: :cms do
#    pipe_through [:browser, :auth, :ensure_auth, :ensure_root]
#    get "/admin", AdminController, :index
#    resources "/taxonomy", TaxonomyController
#    resources "/term", TermController
#    resources "/article", ArticleController
#  end

  scope "/api", ThetaWeb.CMS do
    pipe_through [:api, :auth]
    post "/upload", UploadController, :index
    get "/select/:slug", UploadController, :show
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
  defp cookie_test(conn, _) do
    IO.inspect(conn)
    put_resp_cookie(conn, "my-cookie", %{user_id: "teststststse"}, [encrypt: true, same_site: "Strict"])
  end
  def handle_errors(conn, %{kind: _kind, reason: reason, stack: _stack}) do
    path_error = reason.conn.request_path
    ThetaWeb.PV.PathAliasController.router_path_error(conn, path_error)
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
#  if Mix.env() in [:dev, :test] do
#    import Phoenix.LiveDashboard.Router
#
#    scope "/" do
#      pipe_through :browser
#      live_dashboard "/dashboard", metrics: ThetaWeb.Telemetry
#    end
#  end
end
