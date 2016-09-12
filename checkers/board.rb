require_relative 'piece'

require 'colorize'

class Board

  attr_reader :grid

  def initialize(dup = false)
    @grid = Array.new(10) { Array.new(10) }
    setup_new_board unless dup
  end
  # distinguish between king and non-king pieces (use ivar)

  def setup_new_board
    (0..9).each do |col|
      (0..3).each do |row|
        pos = [row, col]
        self[pos] = Piece.new(self, :black, pos) if (row + col) % 2 == 1
        pos = [row + 6, col]
        self[pos] = Piece.new(self, :white, pos) if (row + col) % 2 == 1
      end
    end
  end


  def dup
    dup_board = Board.new(true)

    # dupes each piece and inserts it at correct position in new board
    grid.flatten.compact.select do |piece|
      dup_board[piece.position] = piece.dup(dup_board)
    end

    dup_board
  end


  # takes a sequence of moves
  def perform_moves!(move_seq)
    seq = move_seq
    start_piece = self[seq.first]

    return false if start_piece.nil?

    if start_piece.perform_slide(seq[1])
      return true
    elsif seq.size > 1

      seq[1..-1].each do |to_pos|
        succeed = start_piece.perform_jump(to_pos)
        unless succeed
          raise InvalidMoveError
        end
        start_piece = self[to_pos]
      end

      start_piece.update_king
      return true
    end

    # TODO change this to raise Error, delete T/Fs
    false
  end

  def valid_move_seq?(move_seq)
    new_board = self.dup
    # TODO begin
      return new_board.perform_moves!(move_seq)
      # return true
    # rescue
    # return false
  end

  def perform_moves(seq)
    if valid_move_seq?(seq)
      perform_moves!(seq)
    else
      raise InvalidMoveError
    end
  end

  def pieces_of(color)
    grid.flatten.compact.select { |piece| piece.color == color }
  end

  def [](pos)
    row, col = pos[0], pos[1]
    @grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos[0], pos[1]
    @grid[row][col] = piece
  end

  def display
    puts render
  end

  def render
      grid_str = "    " + ('a'..'j').to_a.join("  ") + "\n"

      (0..9).each do |row|
        line_str = " #{9 - row} "
        (0..9).each do |col|
          place = self[[row, col]]
          bg_color = ((row + col) % 2 == 0) ? :light_white : :white

          if place.nil?
            line_str += "   ".colorize(:background => bg_color)
          else
            line_str += place.render.colorize(:color => :black, :background => bg_color)
          end
        end

        line_str += " #{9 - row}\n"
        grid_str += line_str
      end

      grid_str += "    " + ('a'..'j').to_a.join("  ") + "\n"
    end

end
