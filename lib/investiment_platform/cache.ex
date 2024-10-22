defmodule InvestimentPlatform.Cache do
  @moduledoc false
  use Nebulex.Cache,
    otp_app: :investiment_platform,
    adapter: Nebulex.Adapters.Local
end
