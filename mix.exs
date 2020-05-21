defmodule GeoPartition.MixProject do
  use Mix.Project

  def project do
    [
      app: :geo_partition,
      version: "0.1.1",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: ["lib", "test/support", "lib/topo"],
      description: "Decompose polygons into polygons smaller than a given area",
      source_url: "https://github.com/otherchris/GeoPartition",
      package: [
        name: "geo_partition",
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/otherchris/GeoPartition"}
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 4.0.1"},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:geo, github: "bryanjos/geo"},
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
      {:ex_simple_graph, github: "hopsor/ExSimpleGraph", branch: "update-deps"},
      {:vector, "~> 1.0"},
      {:seg_seg, "~> 0.1"}
    ]
  end
end
