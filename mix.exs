defmodule InvestimentPlatform.MixProject do
  use Mix.Project

  def project do
    [
      app: :investiment_platform,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
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
      mod: {InvestimentPlatform.Application, []},
      extra_applications: [:logger, :runtime_tools]
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
      {:phoenix, "~> 1.7.14"},
      {:phoenix_ecto, "~> 4.6.2"},
      {:ecto_sql, "~> 3.12.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_reload, "~> 1.5.3", only: :dev},
      {:phoenix_live_view, "~> 0.20.17"},
      {:floki, ">= 0.36.3", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.4"},
      {:esbuild, "~> 0.8.2", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2.4", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.17.2"},
      {:finch, "~> 0.19.0"},
      {:telemetry_metrics, "~> 1.0.0"},
      {:telemetry_poller, "~> 1.1.0"},
      {:gettext, "~> 0.26.1"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.3"},
      {:plug_cowboy, "~> 2.7.2"},
      {:credo, "~> 1.7.8", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4.4", only: [:dev, :test], runtime: false},
      {:ex_machina, "~> 2.7.0", only: :test},
      {:nimble_csv, "~> 1.1"},
      {:benchee, "~> 1.3.1", only: :dev},
      {:prom_ex, "~> 1.10.0"},
      {:nebulex, "~> 2.6"},
      {:decorator, "~> 1.4"},
      {:nebulex_redis_adapter, "~> 2.3"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
