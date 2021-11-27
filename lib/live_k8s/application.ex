defmodule LiveK8s.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies)
    myself = Node.self()

    children = [
      {Cluster.Supervisor, [topologies, [name: LiveK8s.ClusterSupervisor]]},
      LiveK8s.Repo,
      LiveK8sWeb.Telemetry,
      {Phoenix.PubSub, name: LiveK8s.PubSub},

      LiveK8sWeb.Endpoint,
      # TODO: This broke once because Nodes is not defined yet
      {Task, fn -> broadcast(myself) end}
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

  # TODO: Save the nodes_topic on persisten_term
  defp broadcast(node) do
    Phoenix.PubSub.broadcast(LiveK8s.PubSub, "nodes_topic", {:new_node, node})
  end
end
