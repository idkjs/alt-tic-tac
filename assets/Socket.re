[@bs.val] [@bs.scope ("window")] external userToken : string = "userToken";
open Phx;

let opts = [%raw {|
    function () {
        return {
            params: {
                token: window.userToken
            }
        }
    }
|}];

let socket = initSocket("/socket", ~opts = opts) |> connectSocket |> putOnClose(() => Js.log("Socket closed"))