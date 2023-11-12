defmodule InvestimentPlatform.Quotes.StockQuote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stock_quotes" do
    field :date, :date
    field :ticker, :string
    field :price, :float
    field :amount, :integer
    field :closing_time, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(stock_quote, attrs) do
    stock_quote
    |> cast(attrs, [:date, :ticker, :price, :amount, :closing_time])
    |> validate_required([:date, :ticker, :price, :amount, :closing_time])
  end
end
