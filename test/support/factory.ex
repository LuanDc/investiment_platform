defmodule InvestimentPlatform.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: InvestimentPlatform.Repo

  alias InvestimentPlatform.Stocks.StockQuote

  def stock_quote_factory do
    %StockQuote{
      ticker: "TICKER01",
      price: 40.0,
      amount: 5,
      date: "2023-11-07",
      closing_time: "090000007"
    }
  end
end
