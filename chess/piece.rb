class Piece

  attr_reader :board, :color
  attr_accessor :position

  def initialize(board, position, color)
    @board, @position, @color = board, position, color
  end

  def valid_moves
    moves.select { |move| !move_into_check?(move) }
  end

  def on_board?(pos)
    pos.all? { |i| i.between?(0,7) }
  end

  def dup(new_board)
    self.class.new(new_board, self.position, self.color)
  end

  def move_into_check?(pos)
    new_board = board.dup
    new_board.move!(self.position, pos)
    new_board.in_check?(self.color)
  end

  def render
    self.color == :white ? self.class::PICTOGRAPH.first : self.class::PICTOGRAPH.last
  end

  def inspect
    { :position => position,
      :color => color,
      :piece => self.class,
      :obj_id => self.object_id.to_s[-5..-1] }.inspect
  end

end
