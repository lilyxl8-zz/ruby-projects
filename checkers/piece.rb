class Piece

  DOWN_DIRS = [[1, 1], [1, -1]]
  UP_DIRS = [[-1, 1], [-1, -1]]

  attr_reader :board, :color, :position, :king

  def initialize(board, color, position, king = false)
    @board = board
    @color = color
    @position = position
    @king = king
  end

  def dup(new_board)
    Piece.new(new_board, color, position, king)
  end

  # use these to perform a _single_ move
  # illegal move returns false; else true
  def perform_slide(finish)
    return false unless valid_slides.include?(finish)
    do_move(finish)
    true
  end

  def perform_jump(finish)
    return false unless valid_jumps.include?(finish)
    # delete eaten piece (must go before do_move updates position)
    eaten_pos = [(finish[0] + position[0]) / 2, (finish[1] + position[1]) / 2]
    board[eaten_pos] = nil

    do_move(finish)
    true
  end

  def do_move(finish)
    board[finish] = self
    board[self.position] = nil
    @position = finish
  end

  # returns dirs piece can move in
  def move_dirs
    return DOWN_DIRS + UP_DIRS if king
    return DOWN_DIRS if color == :black
    return UP_DIRS if color == :white
  end

  def valid_slides
    deltas = move_dirs
    avail = []
    deltas.each { |delta| avail << apply_shift(delta) if valid_move?(delta) }
    avail
  end

  def valid_jumps
    deltas = move_dirs
    avail = []

    deltas.each do |delta|
      eaten_pos = apply_shift(delta)
      eaten_piece = board[eaten_pos]
      next if eaten_piece.nil?

      if eaten_piece.color == opponent_color
        jump_delta = [2 * delta[0], 2 * delta[1]]
        avail << apply_shift(jump_delta) if valid_move?(jump_delta)
      end
    end

    avail
  end

  def apply_shift(delta)
    [position[0] + delta[0], position[1] + delta[1]]
  end

  def valid_move?(delta)
    new_pos = apply_shift(delta)
    on_board?(new_pos) && board[new_pos].nil?
  end

  def update_king
    # TODO refactor
    @king = true if color == :black && position[0] == 9
    @king = true if color == :white && position[0] == 0
  end

  def opponent_color
    color == :black ? :white : :black
  end

  def render
    if color == :white
      king ? " ♔ " : " O "
    else
      king ? " ♚ " : " X "
    end
  end

  # TODO delete, already in Board class
  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, 9) }
  end

  def inspect
   { :color => color,
     :pos => position,
     :king => king,
     :obj_id => self.object_id.to_s[-4..-1] }.inspect
  end

end
