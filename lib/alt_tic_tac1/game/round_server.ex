defmodule AltTicTac1.RoundServer do
  use GenServer
  alias AltTicTac1.Round, as: Round

  def start_new_round do
    id = random_id(20)
    IO.puts id
    Supervisor.start_child(:round_supervisor, [id])
    {:ok, id}
  end

  defp random_id(length) do
     :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  def start_link(round_id) do
    GenServer.start_link(
        __MODULE__,
        :ok,
        name: service_name(round_id)
    )
  end

  def move(id, player_id, move) do
    GenServer.call(service_name(id), {:move, player_id, move})
  end

  def add_player(id) do
    GenServer.call(service_name(id), {:add_player})
  end

  def init(:ok) do
    {:ok, Round.start()}
  end

  def check_player?(id, player_id, player) do
    GenServer.call(service_name(id), {:check_player, player_id, player})
  end

  def handle_call({:move, player_id, move}, _from, r) do
    {:move, player, _, _} = move
    if player == :player_1 && r.player_1 != player_id || player == :player_2 && r.player_2 != player_id do
        {:reply, :wrong_id, r}
    else if r.player_1 == nil or r.player_2 == nil do
        {:reply, :not_enough_players, r}
    else
        case r |> Round.handle_move_request(move) do
            {:ok, r} ->
                {:ok, notifications, r} = Round.get_notifications(r)
                {:reply, {:ok, notifications}, r}

            err -> {:reply, err, r}
        end
    end
    end
  end

  def handle_call({:add_player}, _from, r) do
    id = random_id(19)
    case Round.add_player(r, id) do
        {:ok, r, player} -> {:reply, {:ok, id, player}, r}
        {:no_free_slot} -> {:reply, {:no_free_slot}, r}
    end
  end

  def handle_call({:check_player, player_id, player}, _from, r) do
    case player do
      :player_1 -> if player_id == r.player_1, do: {:reply, true, r}, else: {:reply, false, r}
      :player_2 -> if player_id == r.player_2, do: {:reply, true, r}, else: {:reply, false, r}
      _ -> {:reply, false, r}
    end
  end

  def service_name(round_id) do
    {:via, Registry, {AltTicTac1.RoundRegistry, round_id}}
  end
end