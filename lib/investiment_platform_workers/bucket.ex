defmodule Bucket do
  @moduledoc """
  Script to clean all files from the S3 bucket.
  """

  require Logger
  alias ExAws.S3

  @bucket_name "b3-stock-quotes"

  def list_object do
    %{body: %{contents: objects}} = S3.list_objects(@bucket_name) |> ExAws.request!()
    objects
  end

  def clean_bucket do
    Logger.info("Starting to clean bucket #{@bucket_name}")

    case S3.list_objects(@bucket_name) |> ExAws.request() do
      {:ok, %{body: %{contents: objects}}} when is_list(objects) ->
        objects
        |> Enum.map(& &1.key)
        |> Enum.each(&delete_object/1)

        Logger.info("Bucket #{@bucket_name} cleaned successfully.")
        :ok

      {:ok, %{body: %{contents: nil}}} ->
        Logger.info("Bucket #{@bucket_name} is already empty.")
        :ok

      {:error, reason} ->
        Logger.error(
          "Failed to list objects in bucket #{@bucket_name}. Reason: #{inspect(reason)}"
        )

        {:error, reason}
    end
  end

  defp delete_object(key) do
    Logger.info("Deleting object #{key} from bucket #{@bucket_name}")

    case S3.delete_object(@bucket_name, key) |> ExAws.request() do
      {:ok, _response} ->
        Logger.info("Deleted object #{key} successfully.")

      {:error, reason} ->
        Logger.error("Failed to delete object #{key}. Reason: #{inspect(reason)}")
    end
  end
end
