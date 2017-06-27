defmodule StockScrapingBatch.YahooVolumeDate do
  use Ecto.Schema
  use Timex.Ecto.Timestamps

  @primary_key false
  schema "yahoo_volume_date" do
    field :date, Timex.Ecto.Date, primary_key: true
    field :add_date, Timex.Ecto.DateTime
    field :updt_date, Timex.Ecto.DateTime
  end
end
