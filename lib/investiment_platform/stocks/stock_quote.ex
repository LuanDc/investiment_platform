defmodule InvestimentPlatform.Stocks.StockQuote do
  use Ecto.Schema

  schema "stock_quotes" do
    field :date, :date
    field :ticker, :string
    field :price, :float
    field :amount, :integer
    field :closing_time, :string
  end
end
