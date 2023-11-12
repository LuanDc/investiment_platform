defmodule InvestimentPlatform.Stocks do
  @moduledoc false

  import Ecto.Query

  alias InvestimentPlatform.Repo
  alias InvestimentPlatform.Stocks.StockQuote

  @doc false
  @spec get_max_quote(String.t(), String.t()) :: integer() | nil
  def get_max_quote(ticker, start_date) do
    query =
      from sq in StockQuote,
        where: sq.ticker == ^ticker and sq.date >= ^start_date,
        select: max(sq.price)

    Repo.one(query)
  end
end
