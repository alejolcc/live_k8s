defmodule LiveK8s.Commands do
  @moduledoc """
  Broadcast commands to other nodes

  In order to send commands to other nodes we have 2 options

  1. Do an RPC call to the node with MFA
  We need to know the API of the nodes to use this alternative

  2. Send a message via phoenix_pubsub
  The nodes must subscribe to a topic, so they need to have a " process listener"

  We are going to use the RPC call alternative because we already used the pubsub
  """


  def broadcast_send(n) do
    Node.list(:connected)
    |> Enum.each(fn node ->
      Node.spawn(node, LiveK8sNode, :send_n, [n])
    end)
  end

  def send(node, n) do
    Node.spawn(node, LiveK8sNode, :send_n, [n])
  end
end
