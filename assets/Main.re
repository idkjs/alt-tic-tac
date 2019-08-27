[@react.component]
let make = () => {
    let (state, dispatch) = StateProvider.use();
    let startNewRound = (_event) => {
        let _ = Round.startNewRound(dispatch);
    };

    let joinRound = (_event) => {
        let _ = Round.joinRound(dispatch, state.input);
    };

    let roundString = () => {
     switch state.round {
        | Some(round) => round.roundId ++ ":" ++ round.playerId ++ ":" ++ State.playerToString(round.player)
        | _ => ""
    }
    };

    <div>
        <button onClick={startNewRound}>{React.string("Start new round")}</button>
        <input onChange={(event) => dispatch(ChangeInput(ReactEvent.Form.target(event)##value))}></input>
        <button onClick={joinRound}>{React.string("Join round")}</button>
        <div> {React.string(roundString())} </div>
    </div>
}