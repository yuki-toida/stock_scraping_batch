defmodule StockScrapingBatch.Mixfile do
  use Mix.Project

  def project do
    [
      app: :stock_scraping_batch,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      escript: [main_module: StockScrapingBatch],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {StockScrapingBatch.Application, []}
    ]
  end

  defp deps do
    [
      {:timex, "~> 3.1"},
      {:timex_ecto, "~> 3.1"},
      {:ecto, "~> 2.1.4"},
      {:mariaex, "~> 0.8.2"},
      {:httpoison, "~> 0.11.2"},
      {:floki, "~> 0.17.0"},
      {:tzdata, "0.1.8", override: true},
    ]
  end
end
