use Mix.Config

config :stock_scraping_batch, StockScrapingBatch.Repo,
  adapter: Ecto.Adapters.MySQL,
  database: "stock_scraping",
  username: "root",
  password: "w8uEwio6",
  hostname: "freedb.chy3h8f6gmnh.ap-northeast-1.rds.amazonaws.com",
  port: 3306
