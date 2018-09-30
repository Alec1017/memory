defmodule MemoryWeb.GameChannel do
  use MemoryWeb, :channel

  alias Memory.Game

  def join("game:" <> name, payload, socket) do
    game = Game.new()
    socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
    {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # Resets the game
  def handle_in("new", payload, socket) do
    game = Game.new()
    socket = socket
      |> assign(:game, game)
    {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  end
end
