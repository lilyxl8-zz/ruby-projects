require './tile'

class Board

  WIDTH, HEIGHT = 9, 9
  BOMB_COUNT = 20

  attr_reader :matrix

  def initialize
    @matrix = Array.new(HEIGHT) { Array.new(WIDTH) {nil} }
    populate
  end

  def generate_bomb_pos
    arr_size = WIDTH * HEIGHT
    all = (0...arr_size).to_a
    # TODO user's first revealed tile can't be bomb

    all.sample(BOMB_COUNT).map { |i| [i % WIDTH, i / WIDTH] }
  end

  def populate
    bombs = generate_bomb_pos

    self.each_with_pos do |tile, pos|
      bombs.include?(pos) ? is_bomb = true : is_bomb = false
      self[pos] = Tile.new(self, pos, is_bomb)
    end

    update_tiles
  end

  def each(&block)
    matrix.flatten.each(&block)
  end

  def each_with_pos(&block)
    matrix.each_with_index do |row, row_i|
      row.each_with_index do |tile, col_i|
        block.call(tile, [row_i, col_i])
      end
    end
  end

  def update_tiles
    self.each {|tile| tile.populate_neighbors }
  end

  def [](pos)
    row, col = pos
    matrix[row][col]
  end

  def []=(pos, tile)
    row, col = pos
    matrix[row][col] = tile
  end

  def render(debug_mode = false)
    matrix_str = ""
    self.each do |tile|
      matrix_str += tile.render(debug_mode)
      matrix_str += "\n" if tile.pos[1] == WIDTH - 1
    end
    matrix_str
  end


  def on_board?(pos)
    row, col = pos[0], pos[1]
    (row.between?(0, HEIGHT - 1) && col.between?(0, WIDTH - 1))
  end


  def won?
    self.each do |tile|
      return false unless tile.status == :revealed || tile.is_bomb
    end
    true
  end

end

class Game

  attr_accessor :board, :game_status, :god_mode

  def initialize(board = nil)
    board ? @board = board : @board = Board.new
    @game_status = :in_play
    @god_mode = false
  end

  def display(debug_mode = false)
    puts "debug_mode is #{debug_mode}, god_mode is #{god_mode}"
    puts board.render(debug_mode)
  end

  def get_move
    loop do
      puts "Enter a move (e.g. R,0,0)"
      input = gets.chomp
      # TODO: validate input
      if input == "GOD"
        self.god_mode = true
        puts "god mode activated: #{god_mode}"
        next
      end
      input_array = input.split(",")
      move_hash = move_translate(input_array)
      return move_hash if valid_move?(move_hash)
    end
  end

  def valid_move?(move_hash)
    # TODO: check flag vs reveal
    # TODO: don't allow already revealed square
    board.on_board?(move_hash[:pos])
  end

  def process_move(move_hash)
    if move_hash[:type] == :R
      pos = move_hash[:pos]
      bombed = board[pos].reveal

      @game_status = :lost if bombed
      @game_status = :won if board.won?
    else
      board[pos].flag
    end
  end

  def move_translate(input)
    move_type = input[0].to_sym
    col       = input[1].to_i - 1
    row       = board.matrix.size - input[2].to_i
    { type: move_type, pos: [row, col] }
  end

  def play
    until game_status == :won || game_status == :lost
      display

      display(true) if god_mode

      # TODO refactor
      process_move(get_move)
    end

    puts "You #{game_status.to_s}!"
  end

end

if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.play
end
