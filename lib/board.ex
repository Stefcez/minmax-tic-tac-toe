defmodule Board do
  def create(), do: [
    [ :empty, :empty, :empty ],
    [ :empty, :empty, :empty ],
    [ :empty, :empty, :empty ]
  ]

  def place(board, posX, posY, value) do
    List.update_at(board, posX, fn row ->
      List.replace_at(row, posY, value)
    end)
  end

  def winner(board) do
    rows = board
    cols = columns(board)
    diags = diagonals(board)

    Enum.concat([rows, cols, diags])
    |> Enum.find_value(&winner_row?/1) || :no_winner
  end

  defp winner_row?([a, a, a]) when a != :empty, do: {:winner, a}
  defp winner_row?(_), do: nil

  defp columns(board), do: Enum.zip(board) |> Enum.map(&Tuple.to_list/1)

  defp diagonals(board) do
    [
      [Enum.at(Enum.at(board, 0), 0), Enum.at(Enum.at(board, 1), 1), Enum.at(Enum.at(board, 2), 2)],
      [Enum.at(Enum.at(board, 0), 2), Enum.at(Enum.at(board, 1), 1), Enum.at(Enum.at(board, 2), 0)]
    ]
  end

  def get_possible_moves(board) do
    for {row, i} <- Enum.with_index(board),
        {cell, j} <- Enum.with_index(row),
        cell == :empty do
      {i, j}
    end
  end
end
