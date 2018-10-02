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
      numMatches: 0,
      numClicks: 0,
      first: nil,
      second: nil,
      cards: shuffleCards()
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

  # Converts maps with string keys to atoms
  def atomize(string_map) do
    Map.new(string_map, fn {k, v} -> {String.to_atom(k), v} end)
  end

  # Returns new list of cards after one has been clicked
  def flipCard(game, card) do
    #if game.second == nil and card.isMatched == false do
      newCards = Enum.map(game.cards, fn unflipped -> 
        if unflipped.key == card.key do
          Map.put(unflipped, :isFlipped, true)
            |> Map.put(:color, "yellow")
        else
          unflipped
        end
      end)
      Map.put(game, :cards, newCards)
    # else 
    #   game
    # end
  end


  # Checks if its the first card selected
  def isFirst?(game, card) do
    if game.first == nil do
      Map.put(game, :first, card)
        |> Map.put(:numClicks, (game.numClicks + 1))
    else
      game
    end
  end


  # // Check for second card
  #  if (!this.state.second && this.state.first != card) {
  #    let newState = _.assign({}, this.state, {
  #      second: card,
  #      numClicks: this.state.numClicks + 1
  #    });
  #    this.setState(newState);
  #    setTimeout(() => {
  #      this.channel.push("checkMatch")
  #        .receive("ok"), this.gotView.bind(this)
  #    }, 1000);
  #  }

  # Checks if the card is second to be flipped over
  def isSecond?(game, card) do
    if game.second == nil and game.first.key != card.key do
      Map.put(game, :second, card)
        |> Map.put(:numClicks, game.numClicks + 1)
     else 
       game
     end
  end

  # if (this.state.first.letter == this.state.second.letter) {
  #   newCard = {isMatched: true, color: 'green'};
  #   let newState = _.assign({}, this.state, {numMatches: this.state.numMatches + 1});
  #   this.setState(newState);
  # } else {
  #   newCard = {isFlipped: false, color: 'gray'};
  # }

  # Determines if the selected cards should be considered a match or flipped back over
  def compareSelectedCards(game) do
    if game.first.letter == game.second.letter do
      %{isMatched: true, color: "green"}
    else
      %{isFlipped: false, color: "gray"}
    end
  end


  # let updatedCards = _.map(this.state.cards, (card) => {
  #   if (card.key == this.state.first.key || card.key == this.state.second.key) {
  #     return _.extend(card, newCard);
  #   } else {
  #     return card;
  #   }
  # });

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


# TODO: edit numMatches to make sense, timeout is all out of whack. And you can click a 
# matched card to make it yello again

  # Checks the two selected cards for a match
  def checkMatch(game) do
    if game.first != nil and game.second != nil do
      newCard = compareSelectedCards(game)
      updatedCards = updateCards(game, newCard)
      Map.put(game, :cards, updatedCards)
        |> Map.put(:first, nil)
        |> Map.put(:second, nil)
        |> Map.put(:numMatches, game.numMatches + 1)
    else
      game
    end
  end

end