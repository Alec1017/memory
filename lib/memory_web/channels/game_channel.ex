defmodule MemoryWeb.GameChannel do
  use MemoryWeb, :channel

  alias Memory.Game

  # Joins a channel
  def join("game:" <> name, payload, socket) do
    game = Game.new()
    socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
    {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
  end

  def handle_in("cardClicked", %{"card" => card}, socket) do
    game = Game.cardClicked(socket.assigns[:game], card)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  end

  def handle_in("checkMatch", payload, socket) do
    game = Game.checkMatch(socket.assigns[:game])
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  end

  def handle_in("new", payload, socket) do
    game = Game.new()
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  end
end
