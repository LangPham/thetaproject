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
			extra_applications: [:logger, :runtime_tools, :os_mon]
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
			{:phoenix, "~> 1.5.3"},
			{:phoenix_ecto, "~> 4.0"},
			{:phoenix_html, "~> 2.14"},
			{:phoenix_live_reload, "~> 1.2", only: :dev},
			{:phoenix_live_dashboard, "~> 0.2.0"},
			{:phoenix_live_view, "~> 0.13.3"},
			{:telemetry_metrics, "~> 0.4"},
			{:telemetry_poller, "~> 0.4"},
			{:gettext, "~> 0.11"},
			{:theta, in_umbrella: true},
			{:jason, "~> 1.1"},
			{:plug_cowboy, "~> 2.3"},
			{:phoenix_markdown, "~> 1.0"},
			{:earmark, "~> 1.4.6"},
			{:guardian, "~> 2.1"},
			{:oauth2, "~> 2.0"},
			{:waffle, "~> 1.1.0"},
			{:mogrify, "~> 0.7.4"},
			{:theta_media, git: "https://github.com/LangPham/theta_media.git"}
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
