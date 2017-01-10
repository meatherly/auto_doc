defmodule AutoDoc.Mixfile do
  use Mix.Project

  @version "0.0.2"

  def project do
    [app: :auto_doc,
     version: @version,
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     name: "AutoDoc",
     package: package,
     description: description,
     source_url: "https://github.com/meatherly/auto_doc",
     deps: deps,
     docs: [extras: ["README.md"]],
     elixirc_paths: elixirc_paths(Mix.env)]
  end

  def application do
    [applications: [:logger, :plug],
      mod: {AutoDoc, []}]
  end

  defp deps do
    [{:plug, "~> 1.0"},
    {:poison, "~> 1.5 or ~> 2.2 or ~> 3.0"},

    # Docs dependencies
    {:earmark, "~> 1.0", only: :docs},
    {:ex_doc, "~> 0.14", only: :docs}]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp description do
  """
  A package that will create REST API docs based on your ExUnit tests.
  """
  end

  defp package do
      [files: ["lib", "mix.exs", "README*"],
      maintainers: ["Michael Eatherly"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/meatherly/auto_doc"}]
  end
end
