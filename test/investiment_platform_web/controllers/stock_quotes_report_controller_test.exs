defmodule InvestimentPlatformWeb.StockQuotesReportControllerTest do
  use InvestimentPlatformWeb.ConnCase, async: true

  import InvestimentPlatform.Factory

  describe "show/2" do
    test "should return the max daily volume and max range value from the given ticker", %{
      conn: conn
    } do
      insert(:stock_quote, ticker: "TICKER01", date: "2023-11-07", price: 40.0)
      insert(:stock_quote, ticker: "TICKER01", date: "2023-11-08", amount: 80)

      query_params = %{"ticker" => "TICKER01"}
      conn = get(conn, ~p"/stocks_quotes/reports", query_params)

      response = json_response(conn, 200)

      assert response == %{
               "ticker" => "TICKER01",
               "max_daily_volume" => 80,
               "max_range_value" => 40.0
             }
    end

    test "should apply filter by ticker", %{conn: conn} do
      insert(:stock_quote, ticker: "TICKER01", date: "2023-11-08", price: 30.0, amount: 70)
      insert(:stock_quote, ticker: "TICKER02", date: "2023-11-08", price: 40.0, amount: 80)

      query_params = %{"ticker" => "TICKER01", "start_date" => "2023-11-08"}
      conn = get(conn, ~p"/stocks_quotes/reports", query_params)

      response = json_response(conn, 200)

      assert response == %{
               "ticker" => "TICKER01",
               "max_daily_volume" => 70,
               "max_range_value" => 30.0
             }
    end

    test "should apply filter by start_date when it's provided", %{conn: conn} do
      insert(:stock_quote, ticker: "TICKER01", date: "2023-11-08", price: 30.0, amount: 70)
      insert(:stock_quote, ticker: "TICKER01", date: "2023-11-07", price: 40.0, amount: 80)

      query_params = %{"ticker" => "TICKER01", "start_date" => "2023-11-08"}
      conn = get(conn, ~p"/stocks_quotes/reports", query_params)

      response = json_response(conn, 200)

      assert response == %{
               "ticker" => "TICKER01",
               "max_daily_volume" => 70,
               "max_range_value" => 30.0
             }
    end

    test "should ignore filter by start_date when it has invalid date format", %{conn: conn} do
      insert(:stock_quote, ticker: "TICKER01", date: "2023-11-07", price: 30.0, amount: 70)
      insert(:stock_quote, ticker: "TICKER01", date: "2023-11-08", price: 40.0, amount: 80)

      query_params = %{"ticker" => "TICKER01", "start_date" => "08-11-2023"}
      conn = get(conn, ~p"/stocks_quotes/reports", query_params)

      response = json_response(conn, 200)

      assert response == %{
               "ticker" => "TICKER01",
               "max_daily_volume" => 80,
               "max_range_value" => 40.0
             }
    end

    test "should return 0 when stocks quotes is not found", %{conn: conn} do
      query_params = %{"ticker" => "TICKER01", "start_date" => "2023-11-07"}
      conn = get(conn, ~p"/stocks_quotes/reports", query_params)

      response = json_response(conn, 200)

      assert response == %{
               "ticker" => "TICKER01",
               "max_daily_volume" => 0,
               "max_range_value" => 0
             }
    end
  end
end
