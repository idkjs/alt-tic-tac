[@react.component]
let make = () => {
    let (state, dispatch) = State.use();

    let onClick = _ => dispatch(Add(1));

    <div>
        <div> {string_of_int(state.value) -> React.string} </div>
        <button onClick> "Add one more"->React.string </button>
    </div>
}