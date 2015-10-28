// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "deps/phoenix_html/web/static/js/phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

const reduxConnector = (ReactComponent, initialState) => class extends React.Component {
  constructor() {
    super();
    this.state = initialState;
    this.channel = socket.channel("rooms:lobby", {})
    this.channel.join()
      .receive("ok", resp => {
        console.log("Joined successfully", resp)
      })
      .receive("error", resp => { console.log("Unable to join", resp) })
  }
  takeAction(type) {
    this.channel.push(type, this.state)
      .receive("ok", msg => {
        this.setState(msg);
      });
  }
  render() {
    return (
      <div>
        <ReactComponent
          takeAction={this.takeAction.bind(this)}
          reduxState={this.state}
        />
      </div>
    );
  }
}

class Counter extends React.Component {
  render() {
    return (
      <div>
        Clicked: {this.props.reduxState.count}
        <button onClick={this.props.takeAction.bind(this, "increment")}>+</button>
        <button onClick={this.props.takeAction.bind(this, "decrement")}>-</button>
      </div>
    );
  }
}

const ReduxAppliedComponent = reduxConnector(Counter, {count: 0});

React.render(
  <ReduxAppliedComponent />,
  document.getElementById("react-root")
);
