defmodule Game do
  def start() do
    board = Board.create()
    play(board, :x)
  end

  def play(board, :o) do
    row = IO.gets("Enter row (starting at 0): ") |> String.trim() |> String.to_integer()
    column = IO.gets("Enter column (starting at 0): ") |> String.trim() |> String.to_integer()
    input = [row, column]

    if Board.empty_cell?(board, input) do
      board = Board.place(board, Enum.at(input, 0), Enum.at(input, 1), :o)

      if Board.winner?(board) do
        IO.puts("Congratulation player! You won!")
      else
        next_turn(board, :o)
      end
    else
      IO.puts("You can't place there!")
      play(board, :o)
    end
  end

  def play(board, :x) do
    possible_moves = Board.get_possible_moves(board)

    if possible_moves == [] do
      IO.puts("Game over! Draw")
    else
      {{i, j}, _score} = MinMax.best_move(board, :x)
      board = Board.place(board, i, j, :x)

      Board.print_board(board)

      next_turn(board, :x)
    end
  end

  def next_player(:x), do: :o
  def next_player(:o), do: :x

  defp next_turn(board, crr_player) do
    case Board.winner(board) do
      {:winner, player} ->
        IO.puts("Congratulations player #{player}, you won!")

      :no_winner ->
        play(board, next_player(crr_player))
    end
  end
end
