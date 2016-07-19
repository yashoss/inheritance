require_relative 'board'
require_relative 'display'
require_relative 'pieces'

class Chess

  def initialize
    @player1 = 'white'
    @player2 = 'black'
    @mover = @player1
    @prev_mover = @player2
  end

  def run
    game = Display.new
    until game.board.checkmate?(@mover)
      game.select(@mover)
      swap_player
    end
    puts "The winner is #{@prev_mover}!"
  end

  def swap_player
    @mover, @prev_mover = @prev_mover, @mover
  end
end

if __FILE__ == $PROGRAM_NAME
  a = Chess.new
  a.run
end
