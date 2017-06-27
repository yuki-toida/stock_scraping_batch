defmodule StockScrapingBatch.YahooVolume do
  use Ecto.Schema
  use Timex.Ecto.Timestamps

  @primary_key false
  schema "yahoo_volume" do
    field :date, Timex.Ecto.Date, primary_key: true
    field :ranking, :integer, primary_key: true
    field :code, :integer
    field :market, :string
    field :name, :string
    field :price, :float
    field :volume, :integer
    field :volume_average, :integer
    field :volume_rate, :float
  end
end
