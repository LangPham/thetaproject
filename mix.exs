defmodule Theta.Umbrella.MixProject do
  use Mix.Project

  @version "0.0.5"
  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      releases: [
        theta_blog: [
          version: @version,
          include_executables_for: [:unix],
          applications: [
            theta: :permanent,
            theta_web: :permanent
          ]
        ]
      ]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps folder
  defp deps do
    []
  end

  defp aliases do
    [
      theta_install: "cmd --app theta mix ecto.setup",
      theta_digest: "cmd --app theta_web mix phx.digest",
#      thetareset: "cmd --app theta mix ecto.reset",
#      test: ["ecto.create --quiet", "ecto.migrate", "test"],
#      test1: "cmd --app theta mix ecto.setup"
    ]
  end

end
