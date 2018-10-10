defmodule Memory.GameServer do
  use GenServer

  alias Memory.Game

  #Storing game state
  #- one GenServer that stores state for all games
  # stores a map of game name => game state

  ## CLient / Interface

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def view(game, user) do
    # return view of a game for a user
    GenServer.call(__MODULE__, {:view, game, user})
  end

  

  ## Server / Implementation
  def init(state) do
    {:ok, state}
  end

  # starts a new game in case theres no item with that key in the map
  def handle_call({:view, game, user}, _from, state) do
    gg = Map.get(state, game, Game.new)
    {:reply, Game.client_view(gg, user), Map.put(state, game, gg)}
  end



end