defmodule Util.Observer do
  use GenServer

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    :timer.send_interval(10 * 1000, self(), :schedule)
    {:ok, nil}
  end

  def handle_info(:schedule, state) do
    {:ok, hostname} = :inet.gethostname()
    IO.inspect(hostname)
    IO.inspect(Node.list())

    {:noreply, state}
  end
end
