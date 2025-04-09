defmodule InvestimentPlatformWeb.B3DownloaderController do
  use InvestimentPlatformWeb, :controller

  def trigger_download(conn, _params) do
    case B3Downloader.download_and_upload_to_s3() do
      {:ok, message} ->
        json(conn, %{status: "success", message: message})

      {:error, reason} ->
        json(conn, %{status: "error", error: reason})
    end
  end
end
