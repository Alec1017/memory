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
      numMatches: 0,
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
    // we dont want the non-active user to be able to click
    if (window.userName != this.state.active.name) {
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
    let cards = _.map(this.state.cards, (card, index) => {
      return <Card card={card} cardClicked={this.cardClicked.bind(this)} key={index} />;
    });

    if (this.state.numMatches != 8) {
      return (
        <div>
          <div className="row">
            <Header player1={this.state.player1} player2={this.state.player2} active={this.state.active} />
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
        </div>
      );
    } else {
      return (
          <div className="row">
            <Winner player1 ={this.state.player1} player2={this.state.player2} />
          </div>
      );
    }
  }
}

// Displays the end game information
function Winner(props) {
  let winner = "";
  let loser = "";

  if (props.player1.score > props.player2.score) {
    winner = props.player1;
    loser = props.player2;
  }

  if (props.player1.score < props.player2.score) {
    winner = props.player2;
    loser = props.player1;
  }

  if (props.player1.score == props.player2.score) {
    return <div className="end-screen">
      <h4>Tie game!</h4>
      <h4>You each got {props.player1.score} points</h4>
      <a className="button" href="/">Back to lobby</a>
    </div>
  } else {
    return <div className="end-screen">
      <h4>Your winner is: {winner.name} with {winner.score} points</h4>
      <h4>Your loser is: {loser.name} with {loser.score} points</h4>
      <a className="button" href="/">Back to lobby</a>
  </div>
  }
}

// Information displayed at top of page
function Header(props) {
  let p1Status = "still waiting...";
  let p2Status = "still waiting...";
  let p1Score = 0;
  let p2Score = 0;
  let gameStatus = "Current turn: "

  if (props.player1) {
    p1Status = props.player1.name;
    p1Score = props.player1.score;
  }

  if (props.player2) {
    p2Status = props.player2.name;
    p2Score = props.player2.score;
  }

  if (props.active) {
    gameStatus = gameStatus + props.active.name;
  }

  let firstPlayer = `Player 1: ${p1Status}`;
  let secondPlayer = `Player 2: ${p2Status}`;
  let firstScore = `Player 1 Score: ${p1Score}`;
  let secondScore = `Player 2 Score: ${p2Score}`;

  return <div className="row">
    <div className="column">
      <h4>{firstPlayer}</h4>
      <h4>{firstScore}</h4>
    </div>
    <div className="column">
      <h4>{secondPlayer}</h4>
      <h4>{secondScore}</h4>
    </div>
    <div className="row">
      <h4>{gameStatus}</h4>
    </div>
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
