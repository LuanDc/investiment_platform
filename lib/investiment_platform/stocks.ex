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
  def get_max_quote(ticker, start_date) when is_binary(ticker) and is_binary(start_date) do
    query =
      from sq in StockQuote,
        where: sq.ticker == ^ticker,
        select: max(sq.price)

    query = apply_optional_start_date_filter(query, start_date)

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
  def get_max_daily_volume(ticker, start_date) when is_binary(ticker) and is_binary(start_date) do
    query =
      from stq in StockQuote,
        where: stq.ticker == ^ticker,
        group_by: stq.date,
        select: %{amount: sum(stq.amount)}

    query = apply_optional_start_date_filter(query, start_date)

    query =
      from sq in subquery(query),
        select: max(sq.amount)

    Repo.one(query)
  end

  defp apply_optional_start_date_filter(query, ""), do: query

  defp apply_optional_start_date_filter(query, start_date) when is_binary(start_date) do
    case Date.from_iso8601(start_date) do
      {:ok, _datetime} ->
        from q in query, where: q.date >= ^start_date

      {:error, _reason} ->
        query
    end
  end
end
