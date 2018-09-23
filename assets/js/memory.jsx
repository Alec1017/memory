import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function memory_init(root) {
  ReactDOM.render(<Memory />, root);
}

let letters = 'AABBCCDDEEFFGGHH'.split('');

class Memory extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      numMatches: 0,
      numClicks: 0,
      score: 0,
      firstSelected: null,
      secondSelected: null,
      cards: _.shuffle(letters),
      letters: ""
    };
  }

  // flips a card
  flip(index) {
    console.log('flipped!');
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

    let cards = _.map(this.state.cards, (letter, index) => {
      return <Card letter={letter} onClick={this.flip} key={index} />;
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
function Card(params) {
  return <div className="column column-25">
    <div className="card">
      <h4>{params.letter}</h4>
    </div>
  </div>
}
