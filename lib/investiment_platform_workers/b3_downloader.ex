defmodule B3Downloader do
  @moduledoc """
  Module to download stock quotes from B3 and upload them to S3.
  """

  require Logger
  alias ExAws.S3

  @b3_url "https://arquivos.b3.com.br/rapinegocios/tickercsv/2025-04-01"
  @bucket_name "b3-stock-quotes"

  def download_and_upload_to_s3 do
    Logger.info("Starting download from #{@b3_url}")

    case HTTPoison.get(@b3_url, [], follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        file_name = "cotacoes_#{Date.utc_today()}.zip"

        Logger.info(
          "Download successful. Preparing to upload #{file_name} to S3 bucket #{@bucket_name}"
        )

        # Upload the file to S3
        case upload_to_s3(file_name, body) do
          {:ok, _} ->
            respose = "File #{file_name} uploaded successfully to #{@bucket_name} bucket."
            Logger.info(respose)
            {:ok, respose}

          {:error, reason} ->
            respose = "Failed to upload file to S3. Reason: #{inspect(reason)}"
            Logger.error(respose)
            {:error, respose}
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        response = "Failed to download file. Status code: #{status_code}"
        Logger.error(response)
        {:error, response}

      {:error, %HTTPoison.Error{reason: reason}} ->
        message = "Failed to download file. Reason: #{inspect(reason)}"
        Logger.error(message)
        {:error, message}
    end
  end

  defp upload_to_s3(file_name, file_content) do
    Logger.info("Uploading #{file_name} to S3 bucket #{@bucket_name}")

    S3.put_object(@bucket_name, file_name, file_content)
    |> ExAws.request()
    |> case do
      {:ok, response} ->
        Logger.info("Upload successful: #{inspect(response)}")
        {:ok, response}

      {:error, reason} ->
        Logger.error("Upload failed: #{inspect(reason)}")
        {:error, reason}
    end
  end
end
