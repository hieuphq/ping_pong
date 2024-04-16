defmodule Pong.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []

    IO.inspect("pong topoligies #{length(topologies)}")

    children = [
      {Cluster.Supervisor, [topologies, [name: Pong.ClusterSupervisor]]},
      PongWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:pong, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Pong.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Pong.Finch},
      # Start a worker by calling: Pong.Worker.start_link(arg)
      # {Pong.Worker, arg},
      # Start to serve requests, typically the last entry
      PongWeb.Endpoint,
      Supervisor.child_spec(
        {Phoenix.PubSub, name: :pingpong_pubsub, adapter: Phoenix.PubSub.PG2},
        id: :pingpong_pubsub
      ),
      Util.Observer,
      Pong.Listener
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pong.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PongWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
