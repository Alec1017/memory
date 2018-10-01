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

  # // update card to correct color
  # if (this.state.second || card.isMatched) {
  #   return;
  # } else {
  #   let updatedCards = _.map(this.state.cards, (unflipped) => {
  #     if (unflipped.key == card.key) {
  #       return _.extend(unflipped, {isFlipped: true, color: 'yellow'});
  #     } else {
  #       return unflipped;
  #     }
  #   });
  
  #   let newState = _.assign({}, this.state, {
  #     cards: updatedCards
  #   });
  #   this.setState(newState);
  # }

  # Returns new list of cards after one has been clicked
  def flipCard(game, card) do
    if game.second == nil and card.isMatched != nil do
      Enum.map(game.cards, fn unflipped -> 
        if unflipped.key == card.key do
          Map.put(unflipped, :isFlipped, true)
            |> Map.put(:color, "yellow")
        else
          unflipped
        end
      end)
    else 
      game.cards
    end
  end

  # // Check for first card
  # if (!this.state.first) {
  #   let newState = _.assign({}, this.state, {
  #     first: card,
  #     numClicks: this.state.numClicks + 1
  #   });
  #   this.setState(newState);
  #   return;
  # }

  # Checks if its the first card selected, updates state
  def isFirst?(game, card) do
    if game.first != nil do
      Map.put(game, :first, card)
        |> Map.put(game, :numClicks, game.numClicks + 1)
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

  def isSecond?(game, card) do
    if game.second != nil and game.first != card do
      Map.put(game, :second, card)
        |> Map.put(game, :numClicks, game.numClicks + 1)
        |> checkMatch
        |> Task.yield(1000)
      else 
        game
      end
  end


  # Flips a card
  def cardClicked(game, card) do
    IO.puts(inspect(flipCard(game, card)))
    Map.put(game, :cards, flipCard(game, card))
      # |> isFirst?(card)
      # |> isSecond?(card)
  end

  # if (this.state.first.letter == this.state.second.letter) {
  #   newCard = {isMatched: true, color: 'green'};
  #   let newState = _.assign({}, this.state, {numMatches: this.state.numMatches + 1});
  #   this.setState(newState);
  # } else {
  #   newCard = {isFlipped: false, color: 'gray'};
  # }
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
  def updateCards(game, newCard) do
    Enum.map(game.cards, fn card -> 
      if card.key == game.first.key || card.key == game.second.key do
        Enum.each(newCard, fn {k, v} ->
          Map.put(card, k, v)
        end)
      else
        card
      end
    end)
  end

  # let newState = _.assign({}, this.state, {
  #   first: null,
  #   second: null,
  #   cards: updatedCards
  # });
  # this.setState(newState);
  def checkMatch(game) do
    newCard = compareSelectedCards(game)
    updatedCards = updateCards(game, newCard)
    Map.put(game, :cards, updatedCards)
      |> Map.put(:first, nil)
      |> Map.put(:second, nil)
      |> Map.put(:numMatches, game.numMatches + 1)
  end

end