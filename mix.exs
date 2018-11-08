defmodule GeoPartition.MixProject do
  use Mix.Project

  def project do
    [
      app: :geo_partition,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: ["lib", "test/support"]
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
      {:poison, "~> 3.1"},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:geo, "~> 3.0"},
      {:topo, git: "git@github.com:otherchris/topo.git"}
    ]
  end
end
