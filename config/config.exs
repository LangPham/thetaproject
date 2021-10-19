# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :theta,
  ecto_repos: [Theta.Repo]

config :theta_web,
  ecto_repos: [Theta.Repo],
  generators: [
    context_app: :theta
  ]

# Configures the endpoint
config :theta_web,
       ThetaWeb.Endpoint,
       url: [
         host: "localhost"
       ],
       secret_key_base: "AMlTnnYyOp3EWUbwSTawScMyF9IQoVYs/Al8f9dotIWx+eyu7C8SnsNQ5F/wXC7j",
       render_errors: [
         view: ThetaWeb.ErrorView,
         accepts: ~w(html json),
         layout: false
       ],
       pubsub_server: Theta.PubSub,
       live_view: [
         signing_salt: "UnOlvZWl"
       ]

config :theta_web, env: Mix.env()

# Configures Elixir's Logger
config :logger,
       :console,
       format: "$time $metadata[$level] $message\n",
       metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, :template_engines, md: PhoenixMarkdown.Engine

config :mime, :types, %{
  "application/xml" => ["xml"]
}

config :theta_web,
       ThetaWeb.Guardian,
       issuer: "theta_web",
       # put the result of the mix command above here
       secret_key: "liowth"

# Configure Mix tasks and generators
config :theta_media,
  storage: Path.join([Path.dirname(__DIR__), "uploads"])

config :theta_web, ThetaWeb.Gettext, locales: ~w(en vi), default_locale: "vi"

config :cors_plug,
  origin: ["https://theta-vn.cdn.ampproject.org","https://www-theta-vn.cdn.ampproject.org"],
  max_age: 86400,
  methods: ["GET"]

config :cap,
  effect: :deny,
  exception: :root,
  policy: %{
    nil: %{
      :* => :*
    },
    admin: %{
      ThetaWeb.CMS.ArticleController => :*
    },
    mod: %{
      ThetaWeb.CMS.ArticleController => :update
    }
  },
  secret_key: "AMlTnnYyOp3EWUbwSTawScMyF9IQoVYs"

import_config "#{Mix.env()}.exs"
