defmodule ThetaWeb.MixProject do
  use Mix.Project

  def project do
    [
      app: :theta_web,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ThetaWeb.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon, :rsa_ex]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.8"},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4.0"},
      {:phoenix_live_view, "~> 0.15.1"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:theta, in_umbrella: true},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.3"},
      {:floki, "~> 0.27.0"},
      {:earmark, "~> 1.4.14"},
      {:theta_media, "~>0.1.0"},
      {:gi, "~> 0.1.1"},
      {:cors_plug, "~> 2.0"},
      {:rsa_ex, "~> 0.4.0"},
      # 			{:cap, path: "/Volumes/Master/Git/cap"}
      {:cap, "~> 0.1.2"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, we extend the test task to create and migrate the database.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "cmd npm install --prefix assets"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
