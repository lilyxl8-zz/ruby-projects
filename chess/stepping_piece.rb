class SteppingPiece < Piece

  def moves
    move_list = []
    self.class::STEP_MOVES.each do |direction|
      new_pos = position

      new_pos = [new_pos[0] + direction[0], new_pos[1] + direction[1]]
      next unless on_board?(new_pos)

      if board[new_pos].nil?
        move_list << new_pos
      else
        next if board[new_pos].color == color
        move_list << new_pos
      end
    end

    move_list
  end

end

class King < SteppingPiece

  PICTOGRAPH = [" ♔ ", " ♚ "]

  STEP_MOVES = [[1, 1], [1, -1], [-1, 1], [-1, -1],
                [1, 0], [-1, 0], [0, 1], [0, -1]]


end

class Knight < SteppingPiece

  PICTOGRAPH = [" ♘ ", " ♞ "]

  STEP_MOVES = [[-2, -1], [-2,  1], [-1, -2], [-1,  2],
                [ 1, -2], [ 1,  2], [ 2, -1], [ 2,  1]]

end
