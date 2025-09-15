defmodule Game do
  def start() do
    board = Board.create()
    play(board)
  end

  def play(board, crr_player \\ :x) do
    possible_moves = Board.get_possible_moves(board)
    cond do
      length(possible_moves) == 0 ->
        Board.winner(board)

      true ->
        {i, j} = hd(possible_moves)
        board = Board.place(board, i, j, crr_player)

        next_player = if crr_player == :x, do: :o, else: :x
        play(board, next_player)
    end
  end
end
