defmodule MinMax do
  def best_move(board, player) do
    Board.get_possible_moves(board)
    |> Enum.map(fn {i, j} ->
      new_board = Board.place(board, i, j, player)
      score = get_best_move(new_board, player, Game.next_player(player))
      {{i, j}, score}
    end)
    |> Enum.max_by(fn {_move, score} -> score end)
  end

  defp get_best_move(board, target_player, crr_player) do
    case Board.winner(board) do
      {:winner, ^target_player} ->
        1

      {:winner, _other} ->
        -1

      :no_winner ->
        possible_moves = Board.get_possible_moves(board)

        if possible_moves == [] do
          # draw
          0
        else
          scores =
            Enum.map(possible_moves, fn {i, j} ->
              new_board = Board.place(board, i, j, crr_player)
              get_best_move(new_board, target_player, Game.next_player(crr_player))
            end)

          if crr_player == target_player do
            Enum.max(scores)
          else
            Enum.min(scores)
          end
        end
    end
  end
end
