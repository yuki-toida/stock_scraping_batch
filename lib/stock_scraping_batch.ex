defmodule StockScrapingBatch do
  use Timex
  import StockScrapingBatch.Repo
  import Ecto.Query
  import Ecto.Changeset

  def main(args) do
    HTTPoison.get!("https://info.finance.yahoo.co.jp/ranking/?kd=33&mk=2&tm=d&vl=b")
    |> parse
  end

  defp parse(%{status_code: 200, body: body}) do
    volume_elements = Floki.find(body, "tr.rankingTabledata")
    date_elements = Floki.find(body, "div.dtl")

    target_date = parse_date(date_elements)
    target_row = StockScrapingBatch.YahooVolumeDate |> get_by(date: target_date)

    now = Timex.now("Asia/Tokyo")
    naive_datetime = NaiveDateTime.new(DateTime.to_date(now), DateTime.to_time(now)) |> elem(1)

    if target_row do
      # UPDATE MySQL
      changeset = change(target_row, %{updt_date: naive_datetime})
      update(changeset)

      targets = StockScrapingBatch.YahooVolume |> where(date: ^target_date) |> all
      update_volume(volume_elements, target_date, targets)
    else
      # INSERT MySQL
      %StockScrapingBatch.YahooVolumeDate
      {
        date: target_date,
        add_date: naive_datetime,
        updt_date: naive_datetime
      }
      |> insert()

      add_volume(volume_elements, target_date)
    end
  end

  defp parse_date(elements) do
    date_list = elements
    |> Enum.at(0)
    |> elem(2)
    |> Enum.at(1)
    |> String.replace(~r/[^0-9]/, ",")
    |> String.split(",", trim: true)

    year = Enum.at(date_list, 0) |> String.to_integer
    month = Enum.at(date_list, 1) |> String.to_integer
    day = Enum.at(date_list, 2) |> String.to_integer
    Timex.to_date({year, month, day})
  end

  defp update_volume(elements, date, targets) do
    elements |> Enum.each(fn(x) ->
      params = build_map(x, date)
      ranking = params[:ranking]
      target = targets |> Enum.filter(fn(x) -> x.ranking == ranking end) |> hd
      changeset = change(target, params)
      update(changeset)
    end)
  end

  defp add_volume(elements, date) do
    entities = elements |> Enum.map(fn(x) -> build_map(x, date) end)
    insert_all(StockScrapingBatch.YahooVolume, entities)
  end

  defp build_map(value, date) do
    element = elem(value, 2)
    %{
      date: date,
      ranking: get_value(element, 0) |> String.to_integer(),
      code: get_code(element) |> String.to_integer(),
      market: get_value(element, 2),
      name: get_value(element, 3),
      price: get_value(element, 5) |> String.replace(",", "") |> Float.parse() |> elem(0),
      volume: get_value(element, 6) |> String.replace(",", "") |> String.to_integer(),
      volume_average: get_value(element, 7) |> String.replace(",", "") |> String.to_integer(),
      volume_rate: get_value(element, 8) |> String.replace(",", "") |> Float.parse() |> elem(0),
    }
  end

  defp get_value(element, index) do
    Enum.at(element, index)
    |> elem(2)
    |> hd
  end

  defp get_code(element) do
    Enum.at(element, 1)
    |> elem(2)
    |> Enum.at(0)
    |> elem(2)
    |> hd
  end
end
