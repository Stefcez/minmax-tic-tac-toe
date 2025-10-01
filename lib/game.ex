defmodule Game do
  def start() do
    board = Board.create()
    Board.print_board(board)

    starter_move = choose_starting_player()

    play(board, starter_move)
  end

  def play(board, crr_player) do
    # Both cases return a tuple with the row and column so extract each to a variable
    # See which player is currently playing
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
    # MinMax.best_move returns a tuple with the move tuple alongside it's score
    # We ignore the score since we don't need it
    {{i, j}, _score} = MinMax.best_move(board, crr_player)
    IO.puts("AI places #{crr_player} at indexes: [#{i}, #{j}]")

    # Return {i, j} since we need that data to place it later
    {i, j}
  end

  defp human_move(board) do
    IO.puts("It's your turn!")
    row = IO.gets("Enter row (starting at 0): ") |> sanitize_input()
    column = IO.gets("Enter column (starting at 0): ") |> sanitize_input()

    if(valid_input?(board, row, column)) do
      pos = {row, column}
      # Empty cell expects a list, so put row and column in a list
      if Board.empty_cell?(board, pos) && row < length(board) && column < length(board) do
        # Return the tuple of row and column to place it later
        pos
      else
        IO.puts("You can't place there!")
        # Print the board again for clarity
        Board.print_board(board)
        human_move(board)
      end
    else
      IO.puts("Invalid input! Try Again!")
      # Print the board again for clarity
      Board.print_board(board)
      human_move(board)
    end
  end

  defp valid_input?(board, row, column) do
    valid_input?(row, board) && valid_input?(column, Enum.at(board, row))
  end

  defp valid_input?(input, list_to_check) do
    input != nil && is_list(list_to_check) && input < length(list_to_check)
  end

  defp sanitize_input(input) do
    # Check for valid string
    if String.valid?(input) do
      # Return the trimmed and turned to integer string
      input |> String.trim() |> String.to_integer()
    else
      nil
    end
  end

  # Flip the player, if param is :x it will enter the next_player :x
  # If param is :o it will enter the next_player :o
  def next_player(:x), do: :o
  def next_player(:o), do: :x

  defp next_turn(board, crr_player) do
    # Get all possible moves
    possible_moves = Board.get_possible_moves(board)

    # Check the winner of the board
    case Board.winner(board) do
      {:winner, player} ->
        IO.puts("Congratulations player #{player}, you won!")

      :no_winner ->
        # If no more moves left, its a draw
        if possible_moves == [] do
          IO.puts("What a shame, it's a draw!")
        else
          # There are moves, play then next move for the correct player
          play(board, next_player(crr_player))
        end
    end
  end

  defp choose_starting_player() do
    # Choose a random player to begin
    crr_player = Enum.random([:x, :o])

    # Print to the console who will begin
    case crr_player do
      :x -> IO.puts("AI will begin!")
      :o -> IO.puts("You can start!")
    end

    # Return the starting player to start the game
    crr_player
  end
end
