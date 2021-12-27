defmodule LiveK8s.Broadway do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(LiveK8s.Broadway,
      name: __MODULE__,
      producer: [
        module: {LiveK8s.Counter, 1},
        transformer: {__MODULE__, :transform, []},
        concurrency: 1
      ],
      processors: [
        default: [concurrency: 100]
      ],
      batchers: [
        default: [concurrency: 100, batch_size: 100],
      ]
    )
  end

  @impl true
  def handle_message(_processor, message, _context) do
    Message.update_data(message, fn data ->
      Map.to_list(data)
    end)
  end

  @impl true
  def handle_batch(_batch, messages, _batch_info, _context) do
    events = Enum.map(messages, & &1.data)
    LiveK8s.Repo.insert_all(LiveK8s.Tests.Event, events)
    messages
  end

  def transform(event, _opts) do
    %Message{
      data: event,
      acknowledger: {__MODULE__, :ack_id, :ack_data}
    }
  end

  def ack(:ack_id, successful, failed) do
    # Write ack code here
    :ok
  end
end
