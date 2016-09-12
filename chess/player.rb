class Player

end

class HumanPlayer < Player

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def play_turn

    puts "#{color.to_s.capitalize}, it is your turn!"

    get_input

  end

  def get_input

    puts "Enter your move (i.e., e2e4):"
    input = gets.chomp

    if input.length > 4
      raise ArgumentError.new "Please enter a valid move."
    end

    start_pos = convert_pos(input[0..1])
    end_pos = convert_pos(input[2..3])

    [start_pos, end_pos]

  end

  def convert_pos(str)

    row = 8 - str[1].to_i
    col = ('a'..'h').to_a.index(str[0])

    [row, col]

  end

end
