defmodule ThetaWeb.Router do
  use ThetaWeb, :router
  # Todo: enable Plug.ErrorHandler
   use Plug.ErrorHandler

  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admin do
    plug :put_layout, {ThetaWeb.LayoutView, "layout_admin.html"}
    plug Cap
  end

  pipeline :api do
    plug CORSPlug
    plug :accepts, ["json"]
  end

  scope "/amp", ThetaWeb do
    pipe_through :browser
    get "/", AmpController, :index
    get "/policy", AmpController, :policy
    get "/:slug", AmpController, :show
  end

  scope "/", ThetaWeb do
    pipe_through [:browser]
    get "/login", SessionController, :new
    get "/logout", SessionController, :delete
    get "/search", PageController, :google_search
    resources "/sessions", SessionController, only: [:new, :create, :delete], singleton: true
    get "/", PageController, :index
    get "/policy", PageController, :policy
    get "/sitemap.xml", SitemapController, :index
    live "/live", PageLive, layout: {ThetaWeb.LayoutView, "layoutlive.html"}
    get "/media", MediaController, :index
    get "/:slug", PageController, :show
    get "/tag/:slug", PageController, :show
  end

  scope "/auth", ThetaWeb do
    pipe_through :browser
    get "/:provider", OauthController, :index
    get "/:provider/callback", OauthController, :callback
  end

  scope "/user", ThetaWeb do
    pipe_through [:browser]
    get "/me", ProfileController, :index
  end

  scope "/admin", ThetaWeb do
    pipe_through [:browser, :admin]
    resources "/users", UserController
    resources "/config", ConfigController
    resources "/path-error", PV.PathErrorController
    get "/index", CMS.AdminController, :index
    resources "/taxonomy", CMS.TaxonomyController
    resources "/term", CMS.TermController
    resources "/article", CMS.ArticleController
    resources "/qa", CMS.QaController
    live_dashboard "/dashboard", metrics: ThetaWeb.Telemetry
    live "/media-live", MediaLive, layout: {ThetaWeb.LayoutView, "layoutlive.html"}
  end

  scope "/api", ThetaWeb.CMS do
    pipe_through [:api]
    post "/upload", UploadController, :index
    get "/select/:slug", UploadController, :show
  end

  scope "/apiv1", ThetaWeb.Api do
    pipe_through [:api]
    get "/article/:slug", DataController, :show
  end

  def handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    ThetaWeb.ErrorHandler.process_error(conn)
  end

end
