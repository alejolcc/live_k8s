defmodule LiveK8sWeb.Index do
  use LiveK8sWeb, :live_view

  require Logger

  alias LiveK8s.Tests

  def mount(_params, _session, socket) do
    if connected?(socket) do
      LiveK8s.Tests.subscribe()
    end

    events = Tests.list_events()

    assigns = [
      events: events
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_info({:new_events, events}, socket) do
    new_events = Enum.map(events, fn e -> Enum.into(e, %{}) end)
    socket = update(socket, :events, fn events -> new_events ++ events end)

    {:noreply, socket}
  end
end
