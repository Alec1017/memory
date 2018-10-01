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

  // Flips a card
  cardClicked(card) {
    this.channel.push("flipCard", {card: card})
       .receive("ok", this.gotView.bind(this))

    this.channel.push("first?", {card: card})
      .receive("ok", this.gotView.bind(this))

    this.channel.push("second?", {card: card})
      .receive("ok", this.gotView.bind(this))

    setTimeout(() => {
      this.channel.push("checkMatch")
        .receive("ok", this.gotView.bind(this))
    }, 1000)
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
