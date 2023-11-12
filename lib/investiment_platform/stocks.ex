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

  @doc false
  @spec get_max_daily_volume(String.t(), String.t()) :: integer() | nil
  def get_max_daily_volume(ticker, date) do
    sub_query =
      from stq in StockQuote,
        where: stq.ticker == ^ticker and stq.date >= ^date,
        group_by: stq.date,
        select: %{amount: sum(stq.amount)}

    query =
      from sq in subquery(sub_query),
        select: max(sq.amount)

    Repo.one(query)
  end
end
