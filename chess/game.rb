require_relative 'piece'
require_relative 'sliding_piece'
require_relative 'stepping_piece'
require_relative 'pawn'
require_relative 'board'
require_relative 'player'

require 'colorize'

class Game

  attr_reader :board, :white_player, :black_player

  def initialize
    @board = Board.new
    @white_player = HumanPlayer.new(:white)
    @black_player = HumanPlayer.new(:black)
  end

  def play

    end_str = ""
    turn_order = [white_player, black_player]

    loop do
      board.display

      current_player = turn_order.first
      current_color = current_player.color
      input_move = current_player.play_turn

      unless board[input_move[0]].color == current_color
        raise ArgumentError.new "You must move a #{current_color} piece."
      end

      board.move(input_move[0], input_move[1])

      if board.checkmate?(:black)
        end_str = " White has checkmated Black!"
        break
      elsif board.checkmate?(:white)
        end_str = " Black has checkmated White!"
        break
      end

      turn_order.rotate!

    end

    board.display
    puts end_str

  end

end

if __FILE__ == $PROGRAM_NAME

  g = Game.new
  g.play
  
end
