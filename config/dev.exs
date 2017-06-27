use Mix.Config

config :stock_scraping_batch, StockScrapingBatch.Repo,
  adapter: Ecto.Adapters.MySQL,
  database: "stock_scraping",
  username: "ytoida",
  password: "",
  hostname: "127.0.0.1",
  port: 3306
