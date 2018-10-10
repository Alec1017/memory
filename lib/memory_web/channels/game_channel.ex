defmodule MemoryWeb.GameChannel do
  use MemoryWeb, :channel

  alias Memory.GameServer

  # Joins a channel
  def join("game:" <> game, payload, socket) do
    socket = assign(socket, :game, game)
    view = GameServer.view(game, socket.assigns[:user])
    {:ok, %{"join" => game, "game" => view}, socket}
  end

  def handle_in("first?", %{"card" => card}, socket) do
    view = GameServer.first?(socket.assigns[:game], socket.assigns[:user],  card)
    {:reply, {:ok, %{"game" => view}}, socket}
  end

  def handle_in("second?", %{"card" => card}, socket) do
    view = GameServer.second?(socket.assigns[:game], socket.assigns[:user],  card)
    {:reply, {:ok, %{"game" => view}}, socket}  
  end

  def handle_in("flipCard", %{"card" => card}, socket) do
    view = GameServer.flipCard(socket.assigns[:game], socket.assigns[:user],  card)
    {:reply, {:ok, %{"game" => view}}, socket}
  end

  def handle_in("checkMatch", payload, socket) do
    view = GameServer.checkMatch(socket.assigns[:game], socket.assigns[:user])
    {:reply, {:ok, %{"game" => view}}, socket}
  end

  def handle_in("new", payload, socket) do
    view = GameServer.new(socket.assigns[:game], socket.assigns[:user])
    {:reply, {:ok, %{"game" => view}}, socket}
  end
end
