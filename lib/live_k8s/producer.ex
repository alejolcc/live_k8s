defmodule LiveK8s.Counter do
  use GenStage

  @behaviour Broadway.Producer

  def init(_opts) do
    queue = :queue.new()
    :timer.send_interval(100, self(), {:flush, 10000})
    Phoenix.PubSub.subscribe(LiveK8s.PubSub, "user:123")

    state = %{
      queue: queue,
      len: 0
    }

    {:producer, state}
  end

  def handle_demand(demand, state) when demand > 0 do
    {:noreply, [], state}
  end

  def handle_info({:flush, n}, state) do
    elems = min(n, state.len)

    {events_q, queue} = :queue.split(elems, state.queue)
    events = :queue.to_list(events_q)

    new_len = state.len - elems

    {:noreply, events, %{state | queue: queue, len: new_len}}
  end

  def handle_info({_, item}, state) do
    state = %{
      queue: :queue.in(item, state.queue),
      len: state.len + 1
    }

    {:noreply, [], state}
  end
end
