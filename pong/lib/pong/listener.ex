defmodule Pong.Listener do
  use GenServer

  defmodule State do
    defstruct counter: 0
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, %__MODULE__.State{counter: 0}, name: __MODULE__)
  end

  def init(args) do
    Phoenix.PubSub.subscribe(:pingpong_pubsub, "ping")
    {:ok, args}
  end

  def handle_info(msg, state) do
    IO.inspect("#{msg} - Total: #{state.counter + 1}")
    {:noreply, %{state | counter: state.counter + 1}}
  end
end
