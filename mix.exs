defmodule ParamsMap.MixProject do
  use Mix.Project

  @version "0.0.1"
  @github_url "https://github.com/andrewtimberlake/params_map"

  def project do
    [
      app: :params_map,
      name: "ParamsMap",
      description:
        "A utility module for working with Phoenix and LiveView parameters that are typically string-keyed, but can be accessed and updated using atom keys.",
      package: package(),
      version: @version,
      elixir: "~> 1.14",
      deps: deps(),
      docs: docs(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # Docs
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      description:
        "A utility module for working with Phoenix and LiveView parameters that are typically string-keyed, but can be accessed and updated using atom keys.",
      maintainers: ["Andrew Timberlake"],
      contributors: ["Andrew Timberlake"],
      licenses: ["MIT"],
      files: ~w(lib mix.exs README*),
      links: %{"GitHub" => @github_url}
    ]
  end

  defp docs do
    [
      extras: [
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @github_url,
      source_ref: @version,
      canonical: "http://hexdocs.pm/params_map",
      assets: %{"extra_doc/assets" => "assets"},
      formatters: ["html"]
    ]
  end
end
