defmodule InvestimentPlatform.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      InvestimentPlatformWeb.Telemetry,
      InvestimentPlatform.Repo,
      {DNSCluster,
       query: Application.get_env(:investiment_platform, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: InvestimentPlatform.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: InvestimentPlatform.Finch},
      # Start a worker by calling: InvestimentPlatform.Worker.start_link(arg)
      # {InvestimentPlatform.Worker, arg},
      # Start to serve requests, typically the last entry
      InvestimentPlatformWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InvestimentPlatform.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InvestimentPlatformWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
