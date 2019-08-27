defmodule AltTicTac1.EndToEndGameTest do
    use AltTicTac1.Web.ConnCase
    use AltTicTac1.Web.ChannelCase

    alias AltTicTac1.Web.RoomChannel

    setup_all do
       conn = build_conn |> get("/start")
       # Creating round and joining via ajax
       round_id = (conn |> response(200) |> Poison.decode!)["id"]
       player1 = get(build_conn, "/join/" <> round_id) |> response(200) |> Poison.decode!
       player2 = get(build_conn, "/join/" <> round_id) |> response(200) |> Poison.decode!

       # Connectiong with sockets
       {:ok, _, socket1} = socket("player1",  player1)
            |> subscribe_and_join(RoomChannel, "room:" <> round_id)

       {:ok, _, socket2} = socket("player2",  player2)
            |> subscribe_and_join(RoomChannel, "room:" <> round_id)

       {:ok, round_id: round_id, player_1_id: player1["id"], socket1: socket1, socket2: socket2}
    end

    test "Should return an error on any wrong attempt of connection", %{round_id: round_id, player_1_id: player_1_id} do
      {:error, %{reason: "wrong round"}} = socket("player", %{"player_id" => "lol", "player" => "player_1"})
            |> subscribe_and_join(RoomChannel, "room:228")
      {:error, %{reason: "invalid player name"}} = socket("player",  %{"player_id" => "lol", "player" => "ololo"})
            |> subscribe_and_join(RoomChannel, "room:" <> round_id)
      {:error, %{reason: "wrong player id"}} = socket("player", %{"player_id" => "lol", "player" => "player_1"})
            |> subscribe_and_join(RoomChannel, "room:" <> round_id)
    end

    test "Should make a move", %{socket1: socket1, socket2: socket2, round_id: round_id} do
        @endpoint.subscribe("room:" <> round_id)
        Phoenix.ChannelTest.push socket1, "move", %{"field_coords" => {1,2}, "subfield_coords" => {1,2}}
        assert_broadcast "move", %{"notifications" => [{:move, :player_1, {1, 2}, {1, 2}}]}
    end
end
