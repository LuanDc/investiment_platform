defmodule InvestimentPlatform.Stocks do
  @moduledoc """
  This module is responsible for exposing functions about stocks exchange context.
  """

  import Ecto.Query

  alias InvestimentPlatform.Repo
  alias InvestimentPlatform.Stocks.StockQuote

  @doc """
  Returns the maximum daily stock quote. If no stock quotes is found, returns nil.

  ## Example

    iex> Stocks.get_max_quote("TICKER1", "2023-11-10")
    40.0

    iex> Stocks.get_max_quote("TICKER2", "2023-11-10")
    nil

  """
  @spec get_max_quote(String.t(), String.t()) :: integer() | nil
  def get_max_quote(ticker, start_date) do
    query =
      from sq in StockQuote,
        where: sq.ticker == ^ticker and sq.date >= ^start_date,
        select: max(sq.price)

    Repo.one(query)
  end

  @doc """
  Returns the maximum daily stock quote. If no stock quotes is found, returns nil.

  ## Example

    iex> Stocks.get_max_daily_volume("TICKER1", "2023-11-10")
    20

    iex> Stocks.get_max_daily_volume("TICKER2", "2023-11-10")
    nil

  """
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
