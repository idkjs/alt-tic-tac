open State;

exception Invalid;

let joinRound = (dispatch, roundId) => {
  Js.Promise.(
    Fetch.fetch("/api/join/" ++ roundId)
    |> then_(Fetch.Response.text)
    |> then_(resp => {
         let json = Json.parse(resp);
         let _ =
           switch (Json.get("player_id", json)) {
           | Some(String(playerId)) =>
             let _ =
               switch (Json.get("player", json)) {
               | Some(String("player_1")) =>
                 let socket = Socket.initSocket(playerId, "player_1");
                 let channel = Socket.joinRoom(socket, roundId);
                 dispatch(
                   JoinRound(roundId, playerId, Player1, socket, channel),
                 );
               | Some(String("player_2")) =>
                 let socket = Socket.initSocket(playerId, "player_2");
                 let channel = Socket.joinRoom(socket, roundId);
                 dispatch(
                   JoinRound(roundId, playerId, Player2, socket, channel),
                 );
               | _ => ()
               };
           | _ => ()
           };
         resolve();
       })
  );
};

let startNewRound = dispatch => {
  Js.Promise.(
    Fetch.fetch("/api/start")
    |> then_(Fetch.Response.text)
    |> then_(resp => {
         let json = Json.parse(resp);
         switch (Json.get("id", json)) {
         | Some(String(id)) => joinRound(dispatch, id)
         | _ => reject(Invalid)
         };
       })
  );
};