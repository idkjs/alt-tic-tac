type state = {value: int, socket: Phx.Socket.t};
type action =
  | Add(int);

let initialState = {value: 0, socket: Socket.socket};

let reducer = (state, action) => {
  switch (action) {
  | Add(value) =>
    let newState = {...state,value: state.value + value};
    newState;
  };
};

type context = (state, action => unit);
let initialContextValue: context = (initialState, _ => ());

module Provider {
  let stateContext = React.createContext(initialContextValue);
  let make = React.Context.provider(stateContext);

  let makeProps = (~value, ~children, ()) => {
    "value": value,
    "children": children,
  };
}

let use = (): (state, action => unit) => React.useContext(Provider.stateContext);


[@react.component]
let make = (~children) => {
  <Provider
    value={React.useReducer(reducer, initialState)}>
    children
  </Provider>;
};
