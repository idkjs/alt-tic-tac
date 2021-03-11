defmodule AltTicTac1.Mixfile do
  use Mix.Project

  def project do
    [app: :alt_tic_tac1,
     version: "0.0.1",
     elixir: "~> 1.9",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {AltTicTac1.Application, []},
     extra_applications: [:logger, :runtime_tools]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.4.0"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:mix_test_watch, "~> 0.8", only: :dev},
     {:gettext, "~> 0.11"},
     {:plug_cowboy, "~> 2.0"},
     {:plug, "~> 1.7"},
     {:poison, "~> 3.1"},
     {:fs, "~> 6.12"},
     {:mad, "~> 7.1"}]
  end
end
