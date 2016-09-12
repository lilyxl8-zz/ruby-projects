class Player

  attr_reader :color, :board

  def initialize(color, board)
    @color = color
    @board = board
  end

  def play_turn
    puts "#{color.to_s.capitalize}, it is your turn!"
    get_input
    # returns move_seq array of positions
  end

  def get_input


    puts "Enter your move (i.e., d3-e4 or g6-e4-c2):"
    input = gets.chomp
    if input.length < 5
      raise ArgumentError.new "Please enter a valid move."
    end

    move_seq = input.split("-").map { |pos| convert(pos) }
    start_piece = board[move_seq.first]

    if start_piece.nil?
      raise ArgumentError.new "Please enter a valid move."
    end

    unless start_piece.color == color
      raise ArgumentError.new "#{color.capitalize} must move a #{color} piece."
    end

    move_seq
  end

  def convert(pos_str)
    row = 9 - pos_str[1].to_i
    col = ('a'..'j').to_a.index(pos_str[0])

    [row, col]
  end
end
