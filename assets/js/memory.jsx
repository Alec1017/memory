import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function memory_init(root, channel) {
  ReactDOM.render(<Memory channel={channel}/>, root);
}

class Memory extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
    this.state = {
      numMatches: 0,
      numClicks: 0,
      first: null,
      second: null,
      cards: [],
    };

    this.channel.join()
      .receive("ok", this.gotView.bind(this))
      .receive("error", resp => { console.log("Unable to join", resp) })
  }

  gotView(view) {
    this.setState(view.game);
  }

  // Checks for a match
  checkMatch() {
    let newCard = {};
    if (this.state.first.letter == this.state.second.letter) {
      newCard = {isMatched: true, color: 'green'};
      let newState = _.assign({}, this.state, {numMatches: this.state.numMatches + 1});
      this.setState(newState);
    } else {
      newCard = {isFlipped: false, color: 'gray'};
    }

    let updatedCards = _.map(this.state.cards, (card) => {
      if (card.key == this.state.first.key || card.key == this.state.second.key) {
        return _.extend(card, newCard);
      } else {
        return card;
      }
    });

    let newState = _.assign({}, this.state, {
      first: null,
      second: null,
      cards: updatedCards
    });
    this.setState(newState);
  }

  // Flips a card
  cardClicked(card) {
    // update card to correct color
    if (this.state.second || card.isMatched) {
      return;
    } else {
      let updatedCards = _.map(this.state.cards, (unflipped) => {
        if (unflipped.key == card.key) {
          return _.extend(unflipped, {isFlipped: true, color: 'yellow'});
        } else {
          return unflipped;
        }
      });
  
      let newState = _.assign({}, this.state, {
        cards: updatedCards
      });
      this.setState(newState);
    }

    // Check for first card
    if (!this.state.first) {
      let newState = _.assign({}, this.state, {
        first: card,
        numClicks: this.state.numClicks + 1
      });
      this.setState(newState);
      return;
    }

    // Check for second card
    if (!this.state.second && this.state.first != card) {
      let newState = _.assign({}, this.state, {
        second: card,
        numClicks: this.state.numClicks + 1
      });
      this.setState(newState);
      setTimeout(() => {
        this.checkMatch();
      }, 1000);
    }
    
  }

  // Resets the game
  reset() {
    this.channel.push("new")
      .receive("ok", this.gotView.bind(this))
  }

  // Render the game
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
          {cards.slice(0, 4)}
        </div>
        <div className="row">
          {cards.slice(4, 8)}
        </div>
        <div className="row">
          {cards.slice(8, 12)}
        </div>
        <div className="row">
          {cards.slice(12, 16)}
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
  let value = '?'; // ?

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
