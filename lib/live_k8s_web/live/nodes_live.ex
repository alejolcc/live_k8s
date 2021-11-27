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
    Logger.debug("NEW NODE #{new_node}")

    node_list = Node.list()
    socket = assign(socket, :nodes, node_list)

    {:noreply, socket}
  end

  def handle_info(_asd, socket) do

    count = socket.assign.test + 1
    socket = assign(socket, :count, count)

    {:noreply, socket}
  end

end
