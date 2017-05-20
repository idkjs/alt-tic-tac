defmodule AltTicTac1.RoundServerTest do
  use ExUnit.Case
  alias AltTicTac1.RoundServer, as: Round

  setup_all do
    {:ok, _} = Round.start_link(1)
    {:ok, player1_id, :player_1} = Round.add_player(1)
    {:ok, player2_id, :player_2} = Round.add_player(1)
    Supervisor.start_link(AltTicTac1.RoundSupervisor, [])
    {:ok, player1_id: player1_id, player2_id: player2_id}
  end

  test "first move", %{player1_id: player1_id} do
    move = {:move, :player_1, {1, 1}, {1, 1}}
    {:ok, notifications} = Round.move(1, player1_id, move)
    assert notifications == [move]
  end

  test "Get an error on already busied tile", %{player2_id: player2_id} do
    res = Round.move(1, player2_id, {:move, :player_2, {1,1}, {1,1}})
    refute :ok == res
  end

  test "Start with start_new_round function and then find by id" do
    {:ok, id} = Round.start_new_round
    [{new_pid, _}] = Registry.lookup(AltTicTac1.RoundRegistry, id)
  end
end