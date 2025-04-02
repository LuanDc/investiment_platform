defmodule B3Downloader do
  @moduledoc """
  Module to download stock quotes from B3 and upload them to S3.
  """
  use Oban.Worker, queue: :b3_stock_quotes_download

  require Logger
  alias ExAws.S3

  @b3_url "https://arquivos.b3.com.br/rapinegocios/tickercsv/2025-04-01"
  @bucket_name "b3-stock-quotes"
  @file_name "cotacoes_2025-04-01.zip"

  def download_and_upload_to_s3 do
    %{}
    |> __MODULE__.new()
    |> Oban.insert()
  end

  @impl Oban.Worker
  def perform(_args) do
    with {:ok, body} <- download_file(),
         {:ok, _response} <- upload_to_s3(body) do
      Logger.info("B3Downloader completed successfully.")
      {:ok, "File #{@file_name} uploaded successfully to."}
    else
      {:error, reason} ->
        Logger.error("B3Downloader failed. Reason: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp download_file do
    Logger.info("Starting download from #{@b3_url}")

    case HTTPoison.get(@b3_url, [], follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info("Download successful.")
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Failed to download file. Status code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Failed to download file. Reason: #{inspect(reason)}"}
    end
  end

  defp upload_to_s3(body) do
    Logger.info("Uploading #{@file_name} to S3 bucket #{@bucket_name}")

    case S3.put_object(@bucket_name, @file_name, body) |> ExAws.request() do
      {:ok, response} ->
        Logger.info("Upload successful: #{inspect(response)}")
        {:ok, {@bucket_name, @file_name}}

      {:error, reason} ->
        {:error, "Failed to upload file to S3. Reason: #{inspect(reason)}"}
    end
  end
end
