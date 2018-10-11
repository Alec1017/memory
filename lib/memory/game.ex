defmodule Memory.Game do
  # Shuffles the cards
  def shuffleCards do
    "AABBCCDDEEFFGGHH"
      |> String.graphemes
      |> Enum.shuffle
      |> Enum.with_index
      |> Enum.map(fn {letter, index} -> 
        %{letter: letter, isFlipped: false, isMatched: false, color: "gray", key: index}
      end)
  end

  # Initializes the cards
  def new do
    %{
      numClicks: 0,
      first: nil,
      second: nil,
      cards: shuffleCards(),
      player1: nil,
      player2: nil
    }
  end

  # Shows the current state of the game to the client
  def client_view(game, user) do
    %{
      numClicks: game.numClicks,
      first: game.first,
      second: game.second,
      cards: game.cards,
      player1: game.player1,
      player2: game.player2
    }
  end

  # Converts maps with string keys to atoms
  def atomize(string_map) do
    Map.new(string_map, fn {k, v} -> {String.to_atom(k), v} end)
  end

  # Returns new list of cards after one has been clicked
  def flipCard(game, user, card) do
    newCards = Enum.map(game.cards, fn unflipped -> 
      if unflipped.key == card.key do
        Map.put(unflipped, :isFlipped, true)
          |> Map.put(:color, "yellow")
      else
        unflipped
      end
    end)
    Map.put(game, :cards, newCards)
  end


  # Checks if its the first card selected
  def isFirst?(game, user, card) do
    if game.first == nil do
      Map.put(game, :first, card)
        |> Map.put(:numClicks, (game.numClicks + 1))
    else
      game
    end
  end

  # Checks if the card is second to be flipped over
  def isSecond?(game, user, card) do
    if game.second == nil and game.first.key != card.key do
      Map.put(game, :second, card)
        |> Map.put(:numClicks, game.numClicks + 1)
     else 
       game
     end
  end

  # Determines if the selected cards should be considered a match or flipped back over
  def compareSelectedCards(game) do
    if game.first.letter == game.second.letter do
      %{isMatched: true, color: "green"}
    else
      %{isFlipped: false, color: "gray"}
    end
  end

  # Updates the two selected cards to be either both green or gray
  def updateCards(game, newCard) do
    Enum.map(game.cards, fn card -> 
      if card.key == game.first.key || card.key == game.second.key do
        Enum.into(newCard, card)
      else
        card
      end
    end)
  end

  # Checks the two selected cards for a match
  def checkMatch(game, user) do
    if game.first != nil and game.second != nil do
      Process.sleep(1000)
      newCard = compareSelectedCards(game)
      updatedCards = updateCards(game, newCard)
      Map.put(game, :cards, updatedCards)
        |> Map.put(:first, nil)
        |> Map.put(:second, nil)
    else
      game
    end
  end

end