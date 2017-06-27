use Mix.Config

import_config "#{Mix.env}.exs"

config :stock_scraping, ecto_repos: [StockScrapingBatch.Repo]
