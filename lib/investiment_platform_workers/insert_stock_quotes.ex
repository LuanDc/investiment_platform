defmodule InvestimentPlatformWorkers.InsertStockQuotes do
  @moduledoc """
  This module is an adapter that process stock quotes.
  """

  alias InvestimentPlatform.Repo
  alias InvestimentPlatform.Stocks.StockQuote

  NimbleCSV.define(CSV, separator: ";", escape: "\"")

  @doc """
  Reads the content from the given file and insert all quotes in database.
  """
  @spec perform(map()) :: :ok
  def perform(%{"path" => path}) do
    stream =
      path
      |> File.stream!()
      |> CSV.to_line_stream()
      |> CSV.parse_stream()
      |> Stream.map(&parse_raw/1)
      |> Stream.chunk_every(500)

    task_stream =
      Task.Supervisor.async_stream_nolink(
        InvestimentPlatform.TaskSupervisor,
        stream,
        &Repo.insert_all(StockQuote, &1)
      )

    Stream.run(task_stream)
  end

  defp parse_raw([date, ticker, _action, price, amount, closing_time | _rest]) do
    %{
      closing_time: closing_time,
      ticker: ticker,
      price: String.to_float(price),
      date: Date.from_iso8601!(date),
      amount: String.to_integer(amount)
    }
  end
end
