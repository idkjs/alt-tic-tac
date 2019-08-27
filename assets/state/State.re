open Phx

type player = Player1 | Player2;

let playerToString = player => switch player {
| Player1 => "player_1"
| Player2 => "player_2"
};

type round = {
  roundId: string,
  playerId: string,
  player: player,
  socket: Socket.t,
  channel: Phx_push.t
};

type state = {
  input: string,
  round: option(round)
};

let initState = () => { 
  {round: None, input: ""}
};

let initialState = initState()

type action =
  | JoinRound(string, string, player, Socket.t, Phx_push.t)
  | ChangeInput(string)
  | NoEff;

let reducer = (state, action) => {
  switch (action) {
  | JoinRound(roundId, playerId, player, socket, channel) =>
    {...state, round: Some({
      roundId,
      playerId,
      player,
      socket,
      channel
    })}

  | ChangeInput(newInput) => {...state, input: newInput}
  | NoEff => state
  };
};
