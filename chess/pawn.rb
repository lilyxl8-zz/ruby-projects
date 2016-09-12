class Pawn < Piece

  PICTOGRAPH = [" ♙ ", " ♟ "]

  def moves
    i, row = self.color == :black ? [1, 1] : [-1, 6]

    new_moves = []
    fwd_pos = [position[0] + i, position[1]]

    if board[fwd_pos].nil?
      new_moves << fwd_pos if on_board?(fwd_pos)

      two_fwd_pos = [position[0] + 2 * i, position[1]]
      new_moves << two_fwd_pos if at_start?(row) && board[two_fwd_pos].nil?
    end

    # checks diagonal captures
    [-1, 1].each do |j|
      diag_pos = [position[0] + i, position[1] + j]
      new_moves << diag_pos if on_board?(diag_pos) && !board[diag_pos].nil?
    end

    new_moves
  end

  def at_start?(row)
    position[0] == row
  end

end
