defmodule AutoDoc.Mixfile do
  use Mix.Project

  @version "0.0.1"

  def project do
    [app: :auto_doc,
     version: @version,
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     name: "AutoDoc",
     source_url: "https://github.com/meatherly/auto_doc",
     deps: deps,
     docs: [extras: ["README.md"]],
     elixirc_paths: elixirc_paths(Mix.env)]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :plug],
      mod: {AutoDoc, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:plug, "~> 1.0"},
    {:poison, "~> 1.5"},

    # Docs dependencies
    {:earmark, "~> 0.1", only: :docs},
    {:ex_doc, "~> 0.10", only: :docs}]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
