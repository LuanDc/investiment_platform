defmodule InvestimentPlatformWeb.StockQuotesReportController do
  @moduledoc """
  Stock quotes report controller module.
  """
  use Phoenix.Controller

  alias InvestimentPlatform.Stocks

  @doc """
  Exposes function to hadle with request made to GET `/stocks_quotes/reports` API resource.
  Accepts `ticker` and `start_date` as query parameters.
  """
  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, params) do
    ticker = Map.get(params, "ticker", "")
    start_date = Map.get(params, "start_date", "")

    task = Task.async(fn -> Stocks.get_max_quote(ticker, start_date) end)
    max_daily_volume = Stocks.get_max_daily_volume(ticker, start_date) || 0
    max_range_value = Task.await(task) || 0

    json(conn, %{
      ticker: ticker,
      max_daily_volume: max_daily_volume,
      max_range_value: max_range_value
    })
  end
end
