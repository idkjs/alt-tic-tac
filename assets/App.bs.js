// Generated by BUCKLESCRIPT VERSION 5.0.6, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var State$ReactHooksTemplate = require("./state/State.bs.js");
var Counter$ReactHooksTemplate = require("./Counter.bs.js");

function handleClick(_event) {
  console.log("clicked!14");
  return /* () */0;
}

function App(Props) {
  Props.message;
  return React.createElement("div", undefined, React.createElement(State$ReactHooksTemplate.make, {
                  children: React.createElement(Counter$ReactHooksTemplate.make, { })
                }));
}

var make = App;

exports.handleClick = handleClick;
exports.make = make;
/* react Not a pure module */