import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function memory_init(root) {
  ReactDOM.render(<Memory />, root);
}

class Memory extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      numMatches: 0,
      numClicks: 0,
      score: 0,
      firstSelected: null,
      secondSelected: null,
      cards: this.initializeCards()
    };
  }

  // Initializes the cards
  initializeCards() {
    let letters = 'AABBCCDDEEFFGGHH'.split('');

    let cards = _.map(_.shuffle(letters), (letter, index) => {
      return {letter: letter, isFlipped: false, isMatched: false, color: 'gray', key: index};
    });

    return cards;
  }

  // Flips a card
  cardClicked(card) {
    let newState = this.state;

    // Check if the card is the first selected
    if (!this.state.firstSelected) {
      newState = _.assign({}, newState, {firstSelected: card});
    }

    // Check if the card is the second selected
    if (!this.state.secondSelected && this.state.firstSelected) {
      newState = _.assign({}, newState, {secondSelected: card});
    }

    // Compare them
  
    let updatedCards = _.map(this.state.cards, (unflipped) => {
      if (unflipped.key == card.key) {
        return _.extend(unflipped, {isFlipped: true, color: 'yellow'});
      } else {
        return unflipped;
      }
    });

    // Create the new state
    newState = _.assign({}, newState, {
      numClicks: this.state.numClicks + 1,
      cards: updatedCards
    });

    this.setState(newState);
  }

  // Resets the game
  reset() {
    let cleanState = _.assign({}, this.state, {
      numMatches: 0,
      numClicks: 0,
      score: 0,
      firstSelected: null,
      secondSelected: null,
      cards: this.initializeCards()
    });

    this.setState(cleanState);
  }

  render() {
    let title = <div className="column">
      <h1>Memory Game</h1>
    </div>

    let cards = _.map(this.state.cards, (card, index) => {
      return <Card card={card} cardClicked={this.cardClicked.bind(this)} key={index} />;
    });

    return (
      <div>
        <div className="row">
          {title}
        </div>
        <div className="row">
          {cards}
        </div>
        <div className="row">
          <div className="column column-50">
            <p>Number of clicks: {this.state.numClicks}</p>
          </div>
          <div className="column column-50">
            <button className="new-game" onClick={this.reset.bind(this)}>New Game</button>
          </div>
        </div>
      </div>
    );
  }
}

// Renders a card
function Card(props) {
  let card = props.card;
  let value = '?';

  if (card.isFlipped) {
    value = card.letter;
  }

  if (card.isMatched) {
    value = '✓';
  }

  return <div className="column column-25">
    <div className={"card card-" + card.color} onClick={() => props.cardClicked(card)}>
      <h4>{value}</h4>
    </div>
  </div>
}
