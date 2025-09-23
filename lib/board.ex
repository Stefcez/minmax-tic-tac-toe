defmodule Board do
  # Create an empty playing field
  def create(),
    do: [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]

  def place(board, posX, posY, value) do
    # Update a value in the row of the board list
    List.update_at(board, posX, fn row ->
      # In the row replace the current value at the y position given to the value given
      List.replace_at(row, posY, value)
    end)
  end

  def winner?(board) do
    winner(board) != :no_winner
  end

  def winner(board) do
    # Get the cols and diagonals of the board
    cols = columns(board)
    diags = diagonals(board)

    # Make an enum of enums of the board
    # Use concat to keep the other lists alive
    Enum.concat([board, cols, diags])
    |> Enum.find_value(&winner_row?/1) || :no_winner
  end

  def get_possible_moves(board) do
    # Get the row including indexes and check if its empty.
    # For each element that is empty put it as a tuple in a list to get all possible moves
    for {row, i} <- Enum.with_index(board),
        {cell, j} <- Enum.with_index(row),
        cell == nil do
      {i, j}
    end
  end

  def empty_cell?(board, {row, col}) do
    # Return true or false based on if the given tuple of position is empty
    Enum.at(Enum.at(board, row), col) == nil
  end

  def print_board(board) do
    # For each row in the list inspect it (print it to the console)
    Enum.each(board, &IO.inspect/1)
    # Add an extra white line for some clarity
    IO.puts("")
  end

  # If a list is given with 3 of the same element it will enter this function
  defp winner_row?([a, a, a]) when a != nil, do: {:winner, a}

  # If there is just a param given but not a list containing 3 of the same elements, it will enter this function
  defp winner_row?(_), do: nil

  # Zip gets for each row all the columns and puts it in a list as a tuple, so after turn it back into a list
  defp columns(board), do: Enum.zip(board) |> Enum.map(&Tuple.to_list/1)

  defp diagonals(board) do
    diagonal = get_diagonal(board)

    # Reverse the board the get the diagonal from bot to top
    rev_board = Enum.reverse(board)
    rev_diagonal = get_diagonal(rev_board)

    [
      diagonal,
      rev_diagonal
    ]
  end

  defp get_diagonal(board) do
    board
    |> Enum.with_index()
    # For each row get the the same column, so row 0, column 0, row 1, column 1
    |> Enum.map(fn {row, index} -> Enum.at(row, index) end)
  end
end
