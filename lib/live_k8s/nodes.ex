defmodule LiveK8s.Nodes do
  @nodes_topic "nodes_topic"

  def get_nodes() do
    Node.list()
  end

  @doc """
  Subscribes the caller to the PubSub topic.
  """
  def subscribe() do
    Phoenix.PubSub.subscribe(LiveK8s.PubSub, @nodes_topic)
  end

  def broadcast(node, _event) do
    Phoenix.PubSub.broadcast(LiveK8s.PubSub, @nodes_topic, {:new_node, node})
    :ok
  end
end
