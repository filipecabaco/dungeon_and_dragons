defmodule DungeonAndDragons.SocketChecker do
  use GenServer

  def init(_), do: {:ok, nil, {:continue, []}}
  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def handle_continue(_, state) do
    Process.send(self(), :clean, [])
    {:noreply, state}
  end

  def handle_info(:clean, state) do
    Enum.each(
      :ets.tab2list(:users),
      fn
        {id, %{root_pid: nil}} ->
          :ets.delete(:users, id)
          :ok

        {id, %{root_pid: root_pid}} ->
          unless Process.alive?(root_pid) do
            :ets.delete(:users, id)
            DungeonAndDragonsWeb.Endpoint.broadcast!("users", "disconnect", %{id: id})
          end
      end
    )

    Process.send_after(self(), :clean, 100)
    {:noreply, state}
  end
end
