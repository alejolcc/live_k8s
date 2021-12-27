defmodule LiveK8sWeb.NodesLive do
  use LiveK8sWeb, :live_view

  require Logger

  alias LiveK8s.Nodes

  def render(assigns) do
    ~H"""
    Myself: <%= Jason.encode!(@myself) %>
    Current nodes: <%= Jason.encode!(@nodes) %>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Nodes.subscribe()
    end

    assigns = [
      nodes: Node.list(),
      myself: Node.self()
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_info({:new_node, new_node}, socket) do
    Logger.info("NEW NODE #{new_node}")
    Node.monitor(new_node, true)

    node_list = Node.list()
    socket = assign(socket, :nodes, node_list)

    {:noreply, socket}
  end

  def handle_info({:nodedown, node}, socket) do
    Logger.info("Node Down #{node}")
    node_list = Node.list()
    socket = assign(socket, :nodes, node_list)

    {:noreply, socket}
  end
end
