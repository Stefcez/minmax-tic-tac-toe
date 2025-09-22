defmodule MinMax do
  def best_move(board, player) do
    moves_with_scores =
      Board.get_possible_moves(board)
      |> Enum.map(fn {i, j} ->
        new_board = Board.place(board, i, j, player)
        score = get_best_move(new_board, player, Game.next_player(player))
        {{i, j}, score}
      end)

    max_score = Enum.max_by(moves_with_scores, fn {_move, score} -> score end) |> elem(1)

    best_moves = Enum.filter(moves_with_scores, fn {_move, score} -> score == max_score end)

    Enum.random(best_moves)
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
