defmodule LiveK8s.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies)

    children = [
      {Cluster.Supervisor, [topologies, [name: LiveK8s.ClusterSupervisor]]},
      # Start the Ecto repository
      LiveK8s.Repo,
      # Start the Telemetry supervisor
      LiveK8sWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveK8s.PubSub},
      # Start the Endpoint (http/https)
      LiveK8sWeb.Endpoint
      # Start a worker by calling: LiveK8s.Worker.start_link(arg)
      # {LiveK8s.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveK8s.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveK8sWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
