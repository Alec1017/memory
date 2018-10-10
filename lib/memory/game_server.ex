defmodule Memory.GameServer do
  use GenServer

  alias Memory.Game

  ## CLient / Interface

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def view(game, user) do
    GenServer.call(__MODULE__, {:view, game, user})
  end

  def first?(game, user, card) do
    GenServer.call(__MODULE__, {:first?, game, user, card})
  end

  def second?(game, user, card) do
    GenServer.call(__MODULE__, {:second?, game, user, card})
  end

  def flipCard(game, user, card) do
    GenServer.call(__MODULE__, {:flipCard, game, user, card})
  end

  def checkMatch(game, user) do
    GenServer.call(__MODULE__, {:checkMatch, game, user})
  end

  def new(game, user) do
    GenServer.call(__MODULE__, {:new, game, user})
  end


  ## Server / Implementation
  def init(state) do
    {:ok, state}
  end

  def handle_call({:view, game, user}, _from, state) do
    gg = Map.get(state, game, Game.new)
    {:reply, Game.client_view(gg, user), Map.put(state, game, gg)}
  end

  def handle_call({:first?, game, user, card}, _from, state) do
    gg = Map.get(state, game, Game.new)
    |> Game.isFirst?(user, Game.atomize(card))
    {:reply,Game.client_view(gg, user), Map.put(state, game, gg)}
  end

  def handle_call({:second?, game, user, card}, _from, state) do
    gg = Map.get(state, game, Game.new)
    |> Game.isSecond?(user, Game.atomize(card))
    {:reply, Game.client_view(gg, user), Map.put(state, game, gg)}
  end

  def handle_call({:flipCard, game, user, card}, _from, state) do
    gg = Map.get(state, game, Game.new)
    |> Game.flipCard(user, Game.atomize(card))
    {:reply, Game.client_view(gg, user), Map.put(state, game, gg)}
  end

  def handle_call({:checkMatch, game, user}, _from, state) do
    gg = Map.get(state, game, Game.new)
    |> Game.checkMatch(user)
    {:reply, Game.client_view(gg, user), Map.put(state, game, gg)}
  end

  def handle_call({:new, game, user}, _from, state) do
    {:reply, Game.client_view(Game.new, user), Map.put(state, game, Game.new)}
  end
end