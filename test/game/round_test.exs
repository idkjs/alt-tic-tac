defmodule AltTicTac1.RoundTest do
  use ExUnit.Case

  alias AltTicTac1.Round

  setup_all do
    r = Round.start()
    {:ok, r: r}
  end

  test "Should make a move", %{r: r} do
    assert is_map(r)
    move = {:move, :player_1 , {1,1},{1,1}}
    {:ok,r} = r |> Round.handle_move_request(move)
    assert r.field[{1, 1}].tiles[{1,1}] == :player_1
    assert r.current_player == :player_2
    assert r.last_move == move
    {:ok, r: r}
  end

  test "Shouldn't make a move with wrong current player", %{r: r} do
    move1 = {:move, :player_1, {1, 1}, {1, 2}}
    move2 = {:move, :player_1, {1, 1}, {1, 0}}
    {:ok, r} = r |> Round.handle_move_request(move1)
    res = r |> Round.handle_move_request(move2)
    assert {:wrong_player} == res
  end

  test "Shouldn't make a move to already busied tile", %{r: r} do
    move1 = {:move, :player_1, {1, 1}, {1, 2}}
    move2 = {:move, :player_2, {1, 1}, {1, 2}}
    {:ok, r} = r |> Round.handle_move_request(move1)
     res = r |> Round.handle_move_request(move2)
    assert {:tile_busied} == res
  end

  test "Shouldn't make a move on an already inactive field", %{r: r} do
    r = put_in r.field[{1,1}].status, :tie
    move = {:move, :player_1, {1, 1}, {1, 2}}
    res = r |> Round.handle_move_request(move)
    assert {:field_inactive} == res
  end

  test "Shouldn't make a move on a wrong subfield, if required one is active", %{r: r} do
    move = {:move, :player_1, {1, 1}, {1, 2}}
    move2 = {:move, :player_2, {1, 1}, {1, 1}}
    {:ok,r} = r |> Round.handle_move_request(move)
    res =  r |> Round.handle_move_request(move2)
    assert {:wrong_subfield} == res
  end

  test "Should make a victory on subfield", %{r: r} do
    r = r #horizontal win
        |> Round.make_move({:move, :player_1, {1, 1}, {0, 0}})
        |> Round.make_move({:move, :player_2, {1, 1}, {1, 1}})
        |> Round.make_move({:move, :player_1, {1, 1}, {0, 1}})
        |> Round.make_move({:move, :player_2, {1, 1}, {2, 0}})
        |> Round.make_move({:move, :player_1, {1, 1}, {0, 2}})
        |> Round.calculate_move_results()
    assert r.field[{1,1}].status == :player_1

    r = r #vertical win
        |> Round.make_move({:move, :player_2, {1, 2}, {0, 0}})
        |> Round.make_move({:move, :player_1, {1, 2}, {1, 1}})
        |> Round.make_move({:move, :player_2, {1, 2}, {1, 0}})
        |> Round.make_move({:move, :player_1, {1, 2}, {0, 2}})
        |> Round.make_move({:move, :player_2, {1, 2}, {2, 0}})
        |> Round.calculate_move_results()
    assert r.field[{1,2}].status == :player_2

    r = r
        |> Round.make_move({:move, :player_1, {2, 2}, {0, 0}})
        |> Round.make_move({:move, :player_2, {2, 2}, {0, 1}})
        |> Round.make_move({:move, :player_1, {2, 2}, {1, 1}})
        |> Round.make_move({:move, :player_2, {2, 2}, {0, 2}})
        |> Round.make_move({:move, :player_1, {2, 2}, {2, 2}})
        |> Round.calculate_move_results()
    assert r.field[{2,2}].status == :player_1

    r = r
        |> Round.make_move({:move, :player_2, {1, 0}, {0, 2}})
        |> Round.make_move({:move, :player_1, {1, 0}, {2, 1}})
        |> Round.make_move({:move, :player_2, {1, 0}, {1, 1}})
        |> Round.make_move({:move, :player_1, {1, 0}, {1, 2}})
        |> Round.make_move({:move, :player_2, {1, 0}, {2, 0}})
        |> Round.calculate_move_results()
    assert r.field[{1,0}].status == :player_2

    r = r
        |> Round.make_move({:move, :player_1, {0, 0}, {0, 0}})
        |> Round.make_move({:move, :player_2, {0, 0}, {0, 1}})
        |> Round.make_move({:move, :player_1, {0, 0}, {1, 1}})
        |> Round.make_move({:move, :player_2, {0, 0}, {0, 2}})
        |> Round.make_move({:move, :player_1, {0, 0}, {2, 2}})
        |> Round.calculate_move_results()
    assert r.field[{0,0}].status == :player_1

    assert hd(r.notifications) == {:global_win, :player_1, :main_diagonal}
  end

  test "Should add 2 players and then return err", %{r: r} do
    {:ok, r, :player_1} = Round.add_player(r, "some_random_string")
    {:ok, r, :player_2} = Round.add_player(r, "another random string")
    assert Round.add_player(r, "more random string") == {:no_free_slot}
  end
end