defmodule InvestimentPlatform.StocksTest do
  use InvestimentPlatform.DataCase, async: true

  import InvestimentPlatform.Factory

  alias InvestimentPlatform.Stocks

  describe "get_max_quote/2" do
    test "should returns the maximum quota from the date provided until current day" do
      attrs = %{ticker: "TICKER01", date: "2023-11-08", price: 40.0}
      stock_quote = insert(:stock_quote, attrs)

      ticker = "TICKER01"
      start_date = "2023-11-08"

      result = Stocks.get_max_quote(ticker, start_date)

      assert result == 40.0
    end

    test "should exclude quotes below the given date" do
      attrs = %{ticker: "TICKER01", date: "2023-11-07", price: 40.0}
      stock_quote = insert(:stock_quote, attrs)

      attrs = %{ticker: "TICKER01", date: "2023-11-08", price: 30.0}
      stock_quote = insert(:stock_quote, attrs)

      ticker = "TICKER01"
      start_date = "2023-11-08"

      result = Stocks.get_max_quote(ticker, start_date)

      assert result == 30.0
    end

    test "should exclude ticker other than the one provided" do
      attrs = %{ticker: "TICKER02", date: "2023-11-08", price: 40.0}
      stock_quote = insert(:stock_quote, attrs)

      attrs = %{ticker: "TICKER01", date: "2023-11-08", price: 30.0}
      stock_quote = insert(:stock_quote, attrs)

      ticker = "TICKER01"
      start_date = "2023-11-08"

      result = Stocks.get_max_quote(ticker, start_date)

      assert result == 30.0
    end
  end
end
