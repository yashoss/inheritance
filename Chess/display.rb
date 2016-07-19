require 'colorize'
require_relative 'board'
require_relative 'cursorable'
# require_relative 'game'

class Display
attr_accessor :board
  include Cursorable
  def initialize(board = Board.new)
    @board = board
    @cursor = [7,0]
  end

  def render
    puts ""
    @board.grid.each_with_index do |row, y|
      print " #{8 - y} "
      row.each_with_index do |col, x|
        if @board.start == [y, x]
          print " #{col} ".black.on_yellow
        elsif @cursor == [y, x]
          print " #{col} ".blue.on_red
        elsif x % 2 == y % 2
          print " #{col} ".black.on_light_blue
        else
          print " #{col} ".black.on_blue
        end
      end
      puts ""
    end
    puts "    A  B  C  D  E  F  G  H "
  end

end
