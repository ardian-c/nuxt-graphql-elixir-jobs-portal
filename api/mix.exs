defmodule Api.Mixfile do
  use Mix.Project

  def project do
    [
      app: :api,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Api.Application, []},
      extra_applications: [:logger, :runtime_tools, :absinthe, :absinthe_plug]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Framework
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_html, "~> 2.10"},
      {:cowboy, "~> 1.0"},
      {:postgrex, ">= 0.0.0"},

      # Plugs
      {:cors_plug, "~> 1.5"},

      # GraphQL
      {:absinthe, "~> 1.4"},
      {:absinthe_plug, "~> 1.4"},
      {:absinthe_ecto, ">= 0.0.0"},
      {:absinthe_phoenix, "~> 1.4.2"},
      {:dataloader, "~> 1.0.1"},
      {:kronky, "~> 0.5.0"},

      # Upload
      {:arc, "~> 0.11.0"},
      {:arc_ecto, "~> 0.11.0"},

      # Utils
      {:gettext, "~> 0.11"},
      {:guardian, "~> 1.0"},
      {:comeonin, "~> 4.0"},
      {:bcrypt_elixir, "~> 1.0"},
      {:poison, "~> 3.1.0"},
      {:hackney, "~> 1.12.1", override: true},
      {:timex, "~> 3.1"},
      {:sweet_xml, "~> 0.6"},
      {:distillery, "~> 1.5", runtime: false},

      # Mails
      {:bamboo, "~> 1.0.0"},

      # Dev
      {:phoenix_live_reload, "~> 1.0", only: :dev}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
