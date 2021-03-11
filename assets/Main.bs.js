// Generated by BUCKLESCRIPT, PLEASE EDIT WITH CARE
'use strict';

var Block = require("bs-platform/lib/js/block.js");
var Curry = require("bs-platform/lib/js/curry.js");
var React = require("react");
var Round$ReactHooksTemplate = require("./state/Round.bs.js");
var State$ReactHooksTemplate = require("./state/State.bs.js");
var StateProvider$ReactHooksTemplate = require("./state/StateProvider.bs.js");

function Main(Props) {
  var match = StateProvider$ReactHooksTemplate.use(/* () */0);
  var dispatch = match[1];
  var state = match[0];
  var startNewRound = function (_event) {
    Round$ReactHooksTemplate.startNewRound(dispatch);
    return /* () */0;
  };
  var joinRound = function (_event) {
    Round$ReactHooksTemplate.joinRound(dispatch, state[/* input */0]);
    return /* () */0;
  };
  var roundString = function (param) {
    var match = state[/* round */1];
    if (match !== undefined) {
      var round = match;
      return round[/* roundId */0] + (":" + (round[/* playerId */1] + (":" + State$ReactHooksTemplate.playerToString(round[/* player */2]))));
    } else {
      return "";
    }
  };
  return React.createElement("div", undefined, React.createElement("button", {
                  onClick: startNewRound
                }, "Start new round"), React.createElement("input", {
                  onChange: (function ($$event) {
                      return Curry._1(dispatch, /* ChangeInput */Block.__(1, [$$event.target.value]));
                    })
                }), React.createElement("button", {
                  onClick: joinRound
                }, "Join round"), React.createElement("div", undefined, roundString(/* () */0)));
}

var make = Main;

exports.make = make;
/* react Not a pure module */
