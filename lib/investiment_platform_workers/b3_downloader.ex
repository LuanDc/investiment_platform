defmodule B3Downloader do
  @moduledoc """
  Module to download stock quotes from B3 and upload them to S3.
  """
  use Oban.Worker, queue: :b3_stock_quotes_download

  require Logger
  alias ExAws.S3
  alias InvestimentPlatformWorkers.InsertStockQuotes

  @b3_url "https://arquivos.b3.com.br/rapinegocios/tickercsv/2025-04-01"
  @bucket_name "b3-stock-quotes"

  def download_and_upload_to_s3 do
    %{}
    |> __MODULE__.new()
    |> Oban.insert()
    |> case do
      {:ok, _job} ->
        {:ok, "File uploaded successfully"}

      {:error, reason} ->
        {:error, "Failed to enqueue job. Reason: #{inspect(reason)}"}
    end
  end

  @impl Oban.Worker
  def perform(_args) do
    with {:ok, {file_name, body}} <- download_file(),
         {:ok, _response} <- upload_to_s3(file_name, body),
         {:ok, _job} <- process_stock_quotes(file_name) do
      Logger.info("B3Downloader completed successfully.")
      :ok
    else
      {:error, reason} ->
        Logger.error("B3Downloader failed. Reason: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp download_file do
    Logger.info("Starting download from #{@b3_url}")

    case HTTPoison.get(@b3_url, [], follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}} ->
        Logger.info("Download successful.")
        {:ok, {check_filename(headers), body}}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Failed to download file. Status code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Failed to download file. Reason: #{inspect(reason)}"}
    end
  end

  defp upload_to_s3(file_name, body) do
    Logger.info("Uploading #{file_name} to S3 bucket #{@bucket_name}")

    case S3.put_object(@bucket_name, file_name, body) |> ExAws.request() do
      {:ok, response} ->
        Logger.info("Upload successful: #{inspect(response)}")
        {:ok, response}

      {:error, reason} ->
        {:error, "Failed to upload file to S3. Reason: #{inspect(reason)}"}
    end
  end

  defp process_stock_quotes(file_name) do
    InsertStockQuotes.insert_stock_quotes(%{
      "bucket_name" => @bucket_name,
      "file_name" => file_name
    })
  end

  defp check_filename(headers) do
    Enum.find(headers, fn {key, _value} -> String.downcase(key) == "content-disposition" end)
    |> case do
      nil ->
        nil

      {_key, value} ->
        Regex.named_captures(~r/filename="?(?<filename>[^"]+)"?/, value)
        |> case do
          %{"filename" => filename} -> filename
          _ -> nil
        end
    end
  end
end
