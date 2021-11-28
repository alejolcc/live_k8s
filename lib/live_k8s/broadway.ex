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
        default: [concurrency: 500]
      ]
    )
  end

  @impl true
  def handle_message(_processor, message, _context) do
    IO.inspect message
    message
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
