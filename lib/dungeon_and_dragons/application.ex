defmodule DungeonAndDragons.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DungeonAndDragonsWeb.Telemetry,
      {Phoenix.PubSub, name: DungeonAndDragons.PubSub},
      DungeonAndDragonsWeb.Endpoint,
      DungeonAndDragons.SocketChecker
    ]

    # User storage
    :ets.new(:users, [:set, :public, :named_table])

    opts = [strategy: :one_for_one, name: DungeonAndDragons.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    DungeonAndDragonsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
