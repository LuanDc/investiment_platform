defmodule InvestimentPlatform.StocksTest do
  use InvestimentPlatform.DataCase, async: true

  import InvestimentPlatform.Factory

  alias InvestimentPlatform.Stocks

  describe "get_max_quote/2" do
    test "should return the maximum quota from the date provided until current day" do
      attrs = %{ticker: "TICKER01", date: "2023-11-08", price: 40.0}
      insert(:stock_quote, attrs)

      ticker = "TICKER01"
      start_date = "2023-11-08"

      result = Stocks.get_max_quote(ticker, start_date)

      assert result == 40.0
    end

    test "should exclude quotes below the given date" do
      attrs = %{ticker: "TICKER01", date: "2023-11-07", price: 40.0}
      insert(:stock_quote, attrs)

      attrs = %{ticker: "TICKER01", date: "2023-11-08", price: 30.0}
      insert(:stock_quote, attrs)

      ticker = "TICKER01"
      start_date = "2023-11-08"

      result = Stocks.get_max_quote(ticker, start_date)

      assert result == 30.0
    end

    test "should exclude ticker other than the one provided" do
      attrs = %{ticker: "TICKER02", date: "2023-11-08", price: 40.0}
      insert(:stock_quote, attrs)

      attrs = %{ticker: "TICKER01", date: "2023-11-08", price: 30.0}
      insert(:stock_quote, attrs)

      ticker = "TICKER01"
      start_date = "2023-11-08"

      result = Stocks.get_max_quote(ticker, start_date)

      assert result == 30.0
    end

    test "shouldn't apply start_date filter when it's an empty string" do
      attrs = %{ticker: "TICKER01", date: "2023-11-07", price: 40.0}
      insert(:stock_quote, attrs)

      attrs = %{ticker: "TICKER01", date: "2023-11-08", price: 30.0}
      insert(:stock_quote, attrs)

      ticker = "TICKER01"
      start_date = ""

      result = Stocks.get_max_quote(ticker, start_date)

      assert result == 40.0
    end

    test "should return null when no stock quote is found" do
      ticker = "TICKER01"
      start_date = "2023-11-08"

      result = Stocks.get_max_quote(ticker, start_date)

      assert result == nil
    end
  end

  describe "get_max_daily_volume/2" do
    test "should return the maximum daily volume from the date provided until current day" do
      attrs = %{ticker: "TICKER01", date: "2023-11-08", amount: 80}
      insert(:stock_quote, attrs)

      attrs = %{ticker: "TICKER01", date: "2023-11-08", amount: 20}
      insert(:stock_quote, attrs)

      ticker = "TICKER01"
      start_date = "2023-11-08"

      result = Stocks.get_max_daily_volume(ticker, start_date)

      assert result == 100
    end

    test "should exclude quotes below the given date" do
      attrs = %{ticker: "TICKER01", date: "2023-11-07", amount: 80}
      insert(:stock_quote, attrs)
      attrs = %{ticker: "TICKER01", date: "2023-11-07", amount: 20}
      insert(:stock_quote, attrs)

      attrs = %{ticker: "TICKER01", date: "2023-11-08", amount: 50}
      insert(:stock_quote, attrs)
      attrs = %{ticker: "TICKER01", date: "2023-11-08", amount: 30}
      insert(:stock_quote, attrs)

      ticker = "TICKER01"
      start_date = "2023-11-08"

      result = Stocks.get_max_daily_volume(ticker, start_date)

      assert result == 80
    end

    test "should exclude ticker other than the one provided" do
      attrs = %{ticker: "TICKER02", date: "2023-11-08", amount: 80}
      insert(:stock_quote, attrs)
      attrs = %{ticker: "TICKER02", date: "2023-11-08", amount: 20}
      insert(:stock_quote, attrs)

      attrs = %{ticker: "TICKER01", date: "2023-11-08", amount: 50}
      insert(:stock_quote, attrs)
      attrs = %{ticker: "TICKER01", date: "2023-11-08", amount: 30}
      insert(:stock_quote, attrs)

      ticker = "TICKER01"
      start_date = "2023-11-08"

      result = Stocks.get_max_daily_volume(ticker, start_date)

      assert result == 80
    end

    test "shouldn't apply start_date filter when it's an empty string" do
      attrs = %{ticker: "TICKER01", date: "2023-11-07", amount: 50}
      insert(:stock_quote, attrs)
      attrs = %{ticker: "TICKER01", date: "2023-11-08", amount: 30}
      insert(:stock_quote, attrs)

      ticker = "TICKER01"
      start_date = ""

      result = Stocks.get_max_daily_volume(ticker, start_date)

      assert result == 50
    end

    test "should return null when no stock quote is found" do
      ticker = "TICKER01"
      start_date = "2023-11-08"

      result = Stocks.get_max_daily_volume(ticker, start_date)

      assert result == nil
    end
  end
end
