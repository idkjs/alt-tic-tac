defmodule AltTicTac1.Web.PageController do
  use AltTicTac1.Web, :controller
  alias AltTicTac1.RoundServer

  def index(conn, _params) do
    render conn, "index_lol.html"
  end

  def start_game(conn, _params) do
    {:ok, id} = RoundServer.start_new_round

    json conn, %{id: id}
  end

  def join_game(conn, %{"id" => round_id}) do
    case RoundServer.add_player(round_id) do
        {:ok, player_id, player}  -> json conn, %{player_id: player_id, player: player}
        {:no_free_slot} -> conn |> send_resp(500, "No free slot")
    end
  end
end
