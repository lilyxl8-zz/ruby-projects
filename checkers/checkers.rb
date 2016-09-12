require_relative 'board'
require_relative 'player'

require 'byebug'

class Game

  attr_reader :board, :white_player, :black_player

  def initialize
    @board = Board.new
    @white_player = Player.new(:white, board)
    @black_player = Player.new(:black, board)
  end

  def play
    turn_order = [white_player, black_player]

    until won?
      board.display
      current_player = turn_order.first
      begin
        input = current_player.play_turn
      # TODO create Argument class
      rescue ArgumentError => e
        board.display
        puts e.message
        retry
      end
      board.perform_moves(input)
      turn_order.rotate!
    end

    board.display
    # TODO other ways to win (cornered)
    winner = board.pieces_of(:white).empty? ? "Black" : "White"
    puts "Game over! Congratulations #{winner}, you won!"
  end

  def won?
    return true if board.pieces_of(:white).empty?
    return true if board.pieces_of(:black).empty?
    return false
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, 9) }
  end

  def at_end_of_board(piece)
  end

end


if __FILE__ == $PROGRAM_NAME

  g = Game.new
  g.play

end
