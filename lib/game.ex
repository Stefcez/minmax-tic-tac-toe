defmodule Game do
  def start() do
    board = Board.create()
    Board.print_board(board)

    starter_move = choose_starting_player()

    play(board, starter_move)
  end

  def play(board, crr_player) do
    {i, j} =
      case crr_player do
        :x -> ai_move(board, crr_player)
        :o -> human_move(board)
      end

    board = Board.place(board, i, j, crr_player)
    Board.print_board(board)

    next_turn(board, crr_player)
  end

  defp ai_move(board, crr_player) do
    {{i, j}, _score} = MinMax.best_move(board, crr_player)
    IO.puts("AI places #{crr_player} at indexes: [#{i}, #{j}]")
    {i, j}
  end

  defp human_move(board) do
    row = IO.gets("Enter row (starting at 0): ") |> String.trim() |> String.to_integer()
    column = IO.gets("Enter column (starting at 0): ") |> String.trim() |> String.to_integer()

    if Board.empty_cell?(board, [row, column]) do
      {row, column}
    else
      IO.puts("You can't place there!")
      human_move(board)
    end
  end

  def next_player(:x), do: :o
  def next_player(:o), do: :x

  defp next_turn(board, crr_player) do
    possible_moves = Board.get_possible_moves(board)

    case Board.winner(board) do
      {:winner, player} ->
        IO.puts("Congratulations player #{player}, you won!")

      :no_winner ->
        if possible_moves == [] do
          IO.puts("What a shame, it's a draw!")
        else
          play(board, next_player(crr_player))
        end
    end
  end

  defp choose_starting_player() do
    crr_player = Enum.random([:x, :o])

    case crr_player do
      :x -> IO.puts("AI will begin!")
      :o -> IO.puts("You can start!")
    end

    crr_player
  end
end
