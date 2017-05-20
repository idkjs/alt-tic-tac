defmodule AltTicTac1.SubField do
    @opaque t :: %__MODULE__{
        status: :active | :player_1 | :player_2 | :tie,
        tiles: %{
            required({0..2, 0..2}) => :player_1 | :player_2 | :blank
       }
    }
    defstruct [:status, :tiles]

    def init do
      % __MODULE__{
          status: :active,
          tiles: (for i <- 0..2, j <- 0..2, do: {i, j})
          |> Stream.zip(Stream.cycle([:blank]))
          |> Enum.into(%{})
      }
    end
end


defmodule AltTicTac1.Round do
  alias __MODULE__
  alias AltTicTac1.SubField

  defstruct [:field, :current_player, :last_move, :notifications, :player_1, :player_2]

  @opaque t :: %Round{
    field: %{
        required({0..2, 0..2}) => SubField.t
    },
    current_player: player,
    last_move: move | {:nothing},
    notifications: [tuple],
    player_1: string,
    player_2: string
  }

  @type move :: {:move, player, {integer, integer, integer, integer}}
#  @type player_instruction ::
  @type player :: atom

  def start do
     %Round{
        field: (for i <- 0..2, j <- 0..2, do: {i, j})
         |> Stream.zip(Stream.cycle([SubField.init]))
         |> Enum.into(%{}),
        current_player: :player_1,
        last_move: {:nothing},
        notifications: [],
        player_1: nil,
        player_2: nil
     }
  end

  def add_player(r, player_id) do
   cond do
     r.player_1 == nil -> {:ok, put_in(r.player_1, player_id), :player_1}
     r.player_2 == nil -> {:ok, put_in(r.player_2, player_id), :player_2}
     true -> {:no_free_slot}
   end
  end

  @spec handle_move_request(t, move) :: t | {}
  def handle_move_request(r, move) do
    case r |> check_move(move) do
        {:ok} ->
            {:ok, r
                |> make_move( move)
                |> calculate_move_results()}
        some_error ->
            some_error
    end
  end

  @spec make_move(t, move) :: t
  def make_move(r, {:move, player, field_coords, subfield_coords} = move) do
    r = put_in r.field[field_coords].tiles[subfield_coords], player
    r = update_in r.current_player, fn
        :player_1 -> :player_2
        :player_2 -> :player_1
    end
    r = put_in r.last_move, move
    r |> push_notification(move)
  end

  @spec check_move(t, move) :: t
  def check_move(r, {:move, player, field_coords, subfield_coords}) do
    cond do
      r.current_player != player -> {:wrong_player}

      r.field[field_coords].tiles[subfield_coords] != :blank -> {:tile_busied}

      r.field[field_coords].status != :active -> {:field_inactive}

      #
      #Checks whether move is made on the right subfield, or if this subfield is inactive, any field is allowed
      r.last_move != {:nothing}
      && elem(r.last_move, 3) != field_coords
      && r.field[field_coords].status == :active -> {:wrong_subfield}

      true -> {:ok}
    end
  end

  def get_notifications(r) do
    notifications = r.notifications
    r = put_in r.notifications, []
    {:ok, notifications, r}
  end


  def calculate_move_results(r) do
    {:move, player, field_coords, subfield_coords} = r.last_move
    r = cond do
       find_horizontal_win(r) ->
        r = put_in r.field[field_coords].status, player
        r |> push_notification({:local_win, player, field_coords, :horizontal, elem(subfield_coords, 0)})
      find_vertical_win(r) ->
        r = put_in r.field[field_coords].status, player
        r |> push_notification({:local_win, player, field_coords, :vertical, elem(subfield_coords, 0)})
      find_main_diagonal_win(r) ->
        r = put_in r.field[field_coords].status, player
        r |> push_notification({:local_win, player, field_coords, :main_diagonal})
      find_secondary_diagonal_win(r) ->
        r = put_in r.field[field_coords].status, player
        r |> push_notification({:local_win, player,  field_coords, :secondary_diagonal})
      true -> r
    end

    if hd(r.notifications) && elem(hd(r.notifications), 0) == :local_win do #in the case of local win occurence check for global win
        cond do
          find_horizontal_win(r) ->
            r |> push_notification({:global_win, player, :horizontal, elem(field_coords, 0)})
         find_vertical_win(r) ->
            r |> push_notification({:global_win, player, :vertical, elem(field_coords, 0)})
          find_main_diagonal_win(r) ->
            r |> push_notification({:global_win, player, :main_diagonal})
          find_secondary_diagonal_win(r) ->
            r |> push_notification({:global_win, player,  :secondary_diagonal})
          true -> r
        end
    else
        r
    end
  end

  defp push_notification(r, notification) do
    update_in r.notifications, &List.insert_at(&1, 0, notification)
  end

  defp find_horizontal_win(r, sub_field? \\ true) do
    {:move, player, field_coords, subfield_coords} = r.last_move
    {i, _} = if sub_field?, do: subfield_coords, else: field_coords
    horizontal_line = for j <- 0..2, do:
                        if sub_field?, do:
                            r.field[field_coords].tiles[{i, j}],
                        else:
                            r.field[{i, j}].status
    Enum.all?(horizontal_line, fn x -> x == player end)
  end

  defp find_vertical_win(r, sub_field? \\ true) do
    {:move, player, field_coords, subfield_coords} = r.last_move
    {_, j} = if sub_field?, do: subfield_coords, else: field_coords
    vertical_line = for i <- 0..2, do:
                        if sub_field?, do:
                            r.field[field_coords].tiles[{i, j}],
                        else:
                            r.field[{i, j}].status
#    IO.puts verticals
    Enum.all?(vertical_line, fn x -> x == player end)
  end

  defp find_main_diagonal_win(r, sub_field? \\ true) do
    {:move, player, field_coords, subfield_coords} = r.last_move
    main_diagonal = for i <- 0..2, do:
                        if sub_field?, do:
                            r.field[field_coords].tiles[{i,i}],
                        else:
                            r.field[{i, i}].status
    Enum.all?(main_diagonal, fn x -> x == player end)
  end

  defp find_secondary_diagonal_win(r, sub_field? \\ true) do
    {:move, player, field_coords, subfield_coords} = r.last_move
    secondary_diagonal = for i <- 0..2, do:
                        if sub_field?, do:
                            r.field[field_coords].tiles[{i,2 - i}],
                        else:
                            r.field[{i, 2 - i}].status
    Enum.all?(secondary_diagonal, fn x -> x == player end)
  end

end