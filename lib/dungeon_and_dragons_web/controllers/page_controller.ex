defmodule DungeonAndDragonsWeb.PageLive do
  use DungeonAndDragonsWeb, :live_view
  @chars File.ls!("./priv/static/images/chars")

  use Agent

  def mount(_, _, %{root_pid: nil} = socket), do: {:ok, socket}

  def mount(_params, _session, socket) do
    new_user = %{
      id: socket.id,
      char: Enum.random(@chars),
      x: Enum.random(1..200),
      y: Enum.random(1..200),
      root_pid: socket.root_pid
    }

    :ets.insert(:users, {socket.id, new_user})

    socket =
      Enum.reduce(:ets.tab2list(:users), socket, fn {_, content}, socket ->
        push_event(socket, "new_user", Map.delete(content, :root_pid))
      end)

    DungeonAndDragonsWeb.Endpoint.subscribe("users")
    DungeonAndDragonsWeb.Endpoint.broadcast!("users", "join", new_user)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="canvas" phx-hook="Canvas" class="h-screen w-screen" user_id={@socket.id} />
    """
  end

  def handle_info(%{topic: "users", event: "join", payload: %{id: id}}, %{id: id} = socket) do
    {:noreply, socket}
  end

  def handle_info(%{topic: "users", event: "join", payload: payload}, socket) do
    {:noreply, push_event(socket, "new_user", Map.delete(payload, :root_pid))}
  end

  def handle_info(%{topic: "users", event: "disconnect", payload: %{id: id}}, socket) do
    {:noreply, push_event(socket, "delete_user", %{id: id})}
  end

  def handle_info(%{topic: "users", event: "move", payload: %{id: id}}, %{id: id} = socket) do
    {:noreply, socket}
  end

  def handle_info(%{topic: "users", event: "move", payload: %{id: id, x: x, y: y}}, socket) do
    {:noreply, push_event(socket, "move_user", %{id: id, x: x, y: y})}
  end

  def handle_event("update_movement", %{"user_id" => id, "x" => x, "y" => y}, %{id: id} = socket) do
    [{_, entry}] = :ets.lookup(:users, id)
    :ets.insert(:users, {id, %{entry | x: x, y: y}})
    DungeonAndDragonsWeb.Endpoint.broadcast!("users", "move", %{id: socket.id, x: x, y: y})
    {:noreply, socket}
  end
end
