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
      numClicks: 0,
      first: null,
      second: null,
      cards: [],
      player1: null,
      player2: null,
      active: null
    };

    this.channel.join()
      .receive("ok", this.gotView.bind(this))
      .receive("error", resp => { console.log("Unable to join", resp) })

    this.channel.push("addPlayer")
      .receive("ok", this.gotView.bind(this))

    // Broadcast updates to view to the client
    this.channel.on("broadcast_view", view => {this.gotView(view)})
  }

  gotView(view) {
    this.setState(view.game);
  }

  // Flips a card
  cardClicked(card) {
    // if active user is not the current user
    // then just return
    //
    // we dont want the non-active user to be able to click
    if (window.userName != this.props.active) {
      return;
    }

    if (card.isMatched) {
      return;
    } else {
      this.channel.push("flipCard", {card: card})
      .receive("ok", this.gotView.bind(this))
    }

    this.channel.push("first?", {card: card})
      .receive("ok", this.gotView.bind(this))
    
    this.channel.push("second?", {card: card})
      .receive("ok", this.gotView.bind(this))

    this.channel.push("checkMatch")
      .receive("ok", this.gotView.bind(this))
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
          <Header player1={this.state.player1} player2={this.state.player2} active={this.state.active} />
        </div>
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

// Information displayed at top of page
function Header(props) {
  let p1Status = "still waiting...";
  let p2Status = "still waiting...";
  let gameStatus = "Current turn: "

  if (props.player1) {
    p1Status = props.player1.name;
  }

  if (props.player2) {
    p2Status = props.player2.name;
  }

  if (props.active) {
    gameStatus = gameStatus + props.active.name;
  }

  let firstMessage = `Player 1: ${p1Status}`;
  let secondMessage = `Player 2: ${p2Status}`;

  console.log(props.player1);
  return <div>
    <h4>{firstMessage}</h4>
    <h4>{secondMessage}</h4>
    <h4>{gameStatus}</h4>
    <p>{window.userName}</p>
  </div>
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
