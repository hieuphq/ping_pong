import Config

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: Pong.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.

config :libcluster,
  topologies: [
    ping: [
      strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
      config: [
        service: "ping-svc",
        application_name: "ping",
        polling_interval: 10_000
      ]
    ],
    pong: [
      strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
      config: [
        service: "pong-svc",
        application_name: "pong",
        polling_interval: 10_000
      ]
    ]
  ]
