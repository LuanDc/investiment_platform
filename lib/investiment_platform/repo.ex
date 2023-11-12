defmodule InvestimentPlatform.Repo do
  use Ecto.Repo,
    otp_app: :investiment_platform,
    adapter: Ecto.Adapters.Postgres
end
