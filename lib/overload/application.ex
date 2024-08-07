defmodule Overload.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OverloadWeb.Telemetry,
      Overload.Repo,
      {DNSCluster, query: Application.get_env(:overload, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Overload.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Overload.Finch},
      # Start a worker by calling: Overload.Worker.start_link(arg)
      # {Overload.Worker, arg},
      {Mongo, name: :mongo, database: "overload", pool_size: 3},
      # Start to serve requests, typically the last entry
      OverloadWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Overload.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OverloadWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
