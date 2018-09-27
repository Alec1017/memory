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
      return {letter: letter, isFlipped: false, isMatched: false, key: index};
    });

    return cards;
  }

  // Flips a card
  cardClicked(card) {
    console.log(card.letter);
  }

  // swap(_ev) {
  //   let state1 = _.assign({}, this.state, { left: !this.state.left });
  //   this.setState(state1);
  // }

  render() {
    // let button = <div className="column" onMouseMove={this.swap.bind(this)}>
    //   <p><button onClick={this.hax.bind(this)}>Click Me</button></p>
    // </div>;

    // Render all the cards with a map

    let title = <div className="column">
      <h1>Memory Game</h1>
    </div>

    console.log(this.initializeCards())

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
            <p>Number of clicks: 8</p>
          </div>
          <div className="column column-50">
            <button>New Game</button>
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

  if (card.isFlipped || card.isMatched) {
    value = card.letter;
  }

  return <div className="column column-25">
    <div className="card" onClick={() => props.cardClicked(card)}>
      <h4>{value}</h4>
    </div>
  </div>
}
