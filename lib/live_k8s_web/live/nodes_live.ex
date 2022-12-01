defmodule LiveK8sWeb.NodesLive do
  use LiveK8sWeb, :live_view

  require Logger

  alias LiveK8s.Nodes

  def render(assigns) do
    # Myself: <%= Jason.encode!(@myself) %>
    # Current nodes: <%= Jason.encode!(@nodes) %>
    ~H"""

    <div class="grid grid-cols-1 divide-y-4">
      <div>
        <h3 class="text-3xl font-bold mb-8">Server</h3>
          <div class="flex space-x-2 justify-center">
            <.circle node_name={@myself} />
          </div>
      </div>

      <div>
        <h3 class="text-3xl font-bold mb-8">Nodes</h3>
          <div class="flex space-x-2 justify-center">
          <%= for node <- @nodes do %>
            <.circle node_name={node} />
          <% end %>
          </div>
      </div>

      <div>
      </div>


      <form phx-submit="send_events">
      <div class="flex items-center justify-center">
        <div class="inline-flex shadow-md hover:shadow-lg focus:shadow-lg" role="group">
          <input
            type="text"
            class=" form-control block px-2 py-1 text-sm font-normal text-gray-700 bg-white bg-clip-padding
              border border-solid border-gray-300 rounded transition ease-in-out m-0
              focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none
            "
            id="exampleFormControlInput4"
            placeholder="N events"
          />
          <button type="button" class=" inline-block px-6 py-2.5 bg-blue-600 text-white font-medium text-xs leading-tight uppercase hover:bg-blue-700 focus:bg-blue-700 focus:outline-none focus:ring-0 active:bg-blue-800 transition duration-150 ease-in-out">Send</button>
        </div>
      </div>
      </form>

    </div>

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

  def handle_event("send_events", args, socket) do
    IO.inspect "ENTRA"
    IO.inspect args
    {:noreply, socket}
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

  def circle(assigns) do
    ~H"""
    <div class="w-40 h-40 bg-green-500 rounded-full border-2 border-black flex justify-center items-center">
         <p><%= assigns.node_name %></p>
    </div>
    """
  end
end
