defmodule Ping.Sender do
  alias Cluster.Strategy.State
  use GenServer

  defmodule State do
    defstruct [
      :node_name,
      :counter
    ]
  end

  def start_link(_) do
    node_name = Node.self() |> IO.inspect(label: "Sender Node")

    GenServer.start_link(__MODULE__, %__MODULE__.State{counter: 0, node_name: node_name},
      name: __MODULE__
    )
  end

  def init(args) do
    :timer.send_interval(5 * 1000, self(), :schedule)
    {:ok, args}
  end

  def handle_info(:schedule, state) do
    new_state = %State{state | counter: state.counter + 1}
    msg = "Ping from #{state.node_name} - #{state.counter}"

    IO.inspect(msg)
    Phoenix.PubSub.broadcast(:pingpong_pubsub, "ping", msg)
    {:noreply, new_state}
  end
end
