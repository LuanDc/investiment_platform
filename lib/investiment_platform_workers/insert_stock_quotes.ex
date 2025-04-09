defmodule InvestimentPlatformWorkers.InsertStockQuotes do
  use Oban.Worker, queue: :stock_quotes_processing

  require Logger

  alias InvestimentPlatform.Repo
  alias InvestimentPlatform.Stocks.StockQuote

  NimbleCSV.define(CSV, separator: ";", escape: "\"")

  def insert_stock_quotes(params) do
    params
    |> __MODULE__.new()
    |> Oban.insert()
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"bucket_name" => bucket_name, "file_name" => file_name}}) do
    Logger.info("Downloading ZIP file #{file_name} from bucket #{bucket_name}")

    bucket_name
    |> read_from_s3_unziped(file_name)
    |> process_file()
  end

  defp read_from_s3_unziped(bucket_name, file_name) do
    aws_s3_config = ExAws.Config.new(:s3)
    file = Unzip.S3File.new(file_name, bucket_name, aws_s3_config)
    {:ok, unzip} = Unzip.new(file)
    file_name = String.replace_suffix(file_name, ".zip", ".txt")
    Unzip.file_stream!(unzip, file_name)
  end

  defp process_file(stream) do
    stream
    |> Stream.map(&IO.iodata_to_binary/1)
    |> CSV.to_line_stream()
    |> CSV.parse_stream(skip_headers: true)
    |> Stream.map(&parse_raw/1)
    |> Stream.chunk_every(100)
    |> Stream.map(&Repo.insert_all(StockQuote, &1, on_conflict: :nothing))
    |> Stream.run()
  end

  defp parse_raw(row) do
    closing_time = Enum.at(row, 5)
    ticker = Enum.at(row, 1)

    date = Enum.at(row, 0) |> Date.from_iso8601!()
    {price, _} = Enum.at(row, 3) |> Float.parse()
    {amount, _} = Enum.at(row, 4) |> Integer.parse()

    event_id = generate_event_id(row)

    %{
      closing_time: closing_time,
      ticker: ticker,
      price: price,
      date: date,
      amount: amount,
      event_id: event_id
    }
  end

  defp generate_event_id(row) do
    sha256 = :crypto.hash(:sha256, row)
    Base.encode16(sha256, case: :lower)
  end
end
