defmodule InvestimentPlatform.Repo.Migrations.CreateStockQuotes do
  use Ecto.Migration

  def change do
    create table(:stock_quotes) do
      add :date, :date
      add :ticker, :string
      add :price, :float
      add :amount, :integer
      add :closing_time, :string
    end
  end
end
