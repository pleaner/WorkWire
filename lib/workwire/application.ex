defmodule Workwire.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WorkwireWeb.Telemetry,
      Workwire.Repo,
      {DNSCluster, query: Application.get_env(:workwire, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Workwire.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Workwire.Finch},
      # Start a worker by calling: Workwire.Worker.start_link(arg)
      # {Workwire.Worker, arg},
      # Start to serve requests, typically the last entry
      WorkwireWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Workwire.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WorkwireWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
