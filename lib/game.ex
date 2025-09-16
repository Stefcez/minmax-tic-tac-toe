defmodule Game do
  def start() do
    board = Board.create()
    play(board)
  end

  def play(board, crr_player \\ :x) do
    case Board.winner(board) do
      {:winner, player} ->
        IO.puts("Winner: #{player}")
        {:winner, player}

      :no_winner ->
        possible_moves = Board.get_possible_moves(board)

        if possible_moves == [] do
          IO.puts("Game over! Draw")
        else
          {{i, j}, _score} = MinMax.best_move(board, crr_player)
          board = Board.place(board, i, j, crr_player)

          Board.print_board(board)

          play(board, next_player(crr_player))
        end
    end
  end

  def next_player(:x), do: :o
  def next_player(:o), do: :x
end
