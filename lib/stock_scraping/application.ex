defmodule StockScrapingBatch.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(StockScrapingBatch.Repo, []),
    ]

    opts = [strategy: :one_for_one, name: StockScrapingBatch.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
