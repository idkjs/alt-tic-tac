[@bs.val] [@bs.scope ("window")] external userToken : string = "userToken";
open Phx;

let opts = [%raw {|
    function (playerId, player) {
        return {
            params: {
               playerId,
               player
            }
        }
    }
|}];

let initSocket = (playerId, player) =>  initSocket("/socket", ~opts = opts(playerId, player)) |> connectSocket |> putOnClose(() => Js.log("Socket closed"))

let joinRoom = (socket, id) => socket |> initChannel("room:" ++ id) |> joinChannel