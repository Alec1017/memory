defmodule Memory.Game do
  # Shuffles the cards
  def shuffleCards do
    "AABBCCDDEEFFGGHH"
      |> String.graphemes
      |> Enum.shuffle
      |> Enum.with_index
      |> Enum.map(fn {letter, index} -> 
        %{letter: letter, isFlipped: false, isMatched: false, color: "gray", key: index} end)
  end

  # Initializes the cards
  def new do
    %{
      numMatches: 0,
      numClicks: 0,
      first: nil,
      second: nil,
      cards: shuffleCards
    }
  end

  # Shows the current state of the game to the client
  def client_view(game) do
    %{
      numMatches: game.numMatches,
      numClicks: game.numClicks,
      first: game.first,
      second: game.second,
      cards: game.cards
    }
  end

end