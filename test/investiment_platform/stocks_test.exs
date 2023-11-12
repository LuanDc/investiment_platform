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
  end
end
