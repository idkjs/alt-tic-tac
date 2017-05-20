defmodule AltTicTac1.Web.RoomChannel do
  use AltTicTac1.Web, :channel
  alias AltTicTac1.RoundServer

  def join("room:" <> round_id, _payload,socket) do
    %{"player_id" => player_id, "player" => player} = socket.assigns
    cond do
        !GenServer.whereis(RoundServer.service_name(round_id)) ->
            {:error, %{reason: "wrong round"}}
        player != "player_1" && player != "player_2" ->
            {:error, %{reason: "invalid player name"}}
        !RoundServer.check_player?(round_id, player_id, String.to_atom(player)) ->
            {:error, %{reason: "wrong player id"}}
        true -> {:ok, socket}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("move", %{"field_coords" => field_coords, "subfield_coords" => subfield_coords}, socket) do
    %{"player_id" => player_id, "player" => player} = socket.assigns
    "room:" <> round_id = socket.topic
    {:ok, notifications} = RoundServer.move(round_id, player_id, {:move, String.to_atom(player), field_coords, subfield_coords})
    broadcast socket, "move", %{"notifications" => notifications}
    {:noreply, socket}
  end

end
