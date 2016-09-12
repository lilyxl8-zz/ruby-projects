class Board

  attr_accessor :matrix

  def initialize(dup = false)
    @matrix = Array.new(8) { Array.new(8) }
    setup_new_board unless dup
  end

  def setup_new_board

    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    (0..7).each do |col|
      [:black, :white].each do |color|
        main_row, pawn_row = (color == :black) ? [0, 1] : [7, 6]
        self[[main_row, col]] = pieces[col].new(self, [main_row, col], color)
        self[[pawn_row, col]] = Pawn.new(self, [pawn_row, col], color)
      end
    end

  end

  def move(start, end_pos)
    piece = self[start]
    if piece.nil?
      raise ArgumentError.new "No piece at start position."

    elsif piece.valid_moves.include?(end_pos)
      move!(start, end_pos)

    else
      raise ArgumentError.new "Not a valid move."
    end
  end

  def move!(start, end_pos)
    piece = self[start]

    self[end_pos] = piece
    self[start] = nil

    piece.position = end_pos
  end

  def in_check?(color)
    color_king = pieces_of(color).find { |piece| piece.is_a?(King) }
    king_pos = color_king.position

    return !pieces_of(toggle_color(color)).none? do |piece|
      piece.moves.include?(king_pos)
    end
  end

  def checkmate?(color)
    if in_check?(color)
      return self.pieces_of(color).all? { |piece| piece.valid_moves.empty? }
    end

    false
  end

  def pieces_of(color)
    matrix.flatten.compact.select { |piece| piece.color == color }
  end

  def toggle_color(color)
    color == :white ? :black : :white
  end

  def dup
    dup_board = Board.new(true)

    matrix.flatten.compact.select do |piece|
      dup_board[piece.position] = piece.dup(dup_board)
    end

    dup_board
  end

  def display
    puts render
  end

  def render
    matrix_str = "    a  b  c  d  e  f  g  h\n"

    (0..7).each do |row|
      line_str = " #{8 - row} "
      (0..7).each do |col|
        place = self[[row, col]]
        bg_color = ((row + col) % 2 == 0) ? :light_white : :white

        if place.nil?
          line_str += "   ".colorize(:background => bg_color)
        else
          line_str += place.render.colorize(:color => :black, :background => bg_color)
        end
      end

      line_str += " #{8 - row}\n"
      matrix_str += line_str
    end

    matrix_str + "    a  b  c  d  e  f  g  h\n"
  end

  def [](pos)
    row, col = pos[0], pos[1]
    @matrix[row][col]
  end

  def []=(pos, piece)
    row, col = pos[0], pos[1]
    @matrix[row][col] = piece
  end

end
