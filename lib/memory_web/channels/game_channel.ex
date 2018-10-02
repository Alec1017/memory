defmodule MemoryWeb.GameChannel do
  use MemoryWeb, :channel

  alias Memory.Game
  alias Memory.Backup

  # Joins a channel
  def join("game:" <> name, payload, socket) do
    game = Backup.get_backup(name) || Game.new()
    socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
    {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
  end

  def handle_in("first?", %{"card" => card}, socket) do
    game = Game.isFirst?(socket.assigns[:game], Game.atomize(card))
    socket = assign(socket, :game, game)
    Backup.backup_state(socket.assigns[:name], game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_in("second?", %{"card" => card}, socket) do
    game = Game.isSecond?(socket.assigns[:game], Game.atomize(card))
    socket = assign(socket, :game, game)
    Backup.backup_state(socket.assigns[:name], game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_in("flipCard", %{"card" => card}, socket) do
    game = Game.flipCard(socket.assigns[:game], Game.atomize(card))
    socket = assign(socket, :game, game)
    Backup.backup_state(socket.assigns[:name], game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_in("checkMatch", payload, socket) do
    game = Game.checkMatch(socket.assigns[:game])
    socket = assign(socket, :game, game)
    Backup.backup_state(socket.assigns[:name], game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_in("new", payload, socket) do
    game = Game.new()
    socket = assign(socket, :game, game)
    Backup.backup_state(socket.assigns[:name], game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end
end
