defmodule MinMax do
  def best_move(board, player) do
    moves_with_scores =
      Board.get_possible_moves(board)
      # For each possible move with the position
      |> Enum.map(fn {i, j} ->
        # Place the current move as the current player
        new_board = Board.place(board, i, j, player)
        # Play out the whole game with this move and get the score
        score = get_best_move(new_board, player, Game.next_player(player))

        # Return the tuple with the move and the score
        {{i, j}, score}
      end)

    # Get the max score reached
    max_score = Enum.max_by(moves_with_scores, fn {_move, score} -> score end) |> elem(1)

    # Create a list with all the max score moves
    best_moves = Enum.filter(moves_with_scores, fn {_move, score} -> score == max_score end)

    # Return a random max score move
    Enum.random(best_moves)
  end

  defp get_best_move(board, target_player, crr_player) do
    case Board.winner(board) do
      # If we win, score is +1
      {:winner, ^target_player} ->
        1

      # if we lose, score is -1
      {:winner, _other} ->
        -1

      :no_winner ->
        possible_moves = Board.get_possible_moves(board)

        if possible_moves == [] do
          # draw, score is 0
          0
        else
          # Get a list for each move with it's score
          scores =
            Enum.map(possible_moves, fn {i, j} ->
              # Place the current move
              new_board = Board.place(board, i, j, crr_player)

              # Again get the best move after this one is placed
              get_best_move(new_board, target_player, Game.next_player(crr_player))
            end)

          # Since the point scoring is from our POV, we want to get the max value.
          if crr_player == target_player do
            Enum.max(scores)
          else
            # Since the point scoring is from our POV, the opponent chooses the min score
            Enum.min(scores)
          end
        end
    end
  end
end
