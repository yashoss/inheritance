require 'colorize'
require 'io/console'
require_relative 'board'
# require_relative 'game'

class Display
attr_accessor :board
  def initialize(board = Board.new)
    @board = board
    @cursor = [0,0]
  end

  def render
    @board.grid.each_with_index do |row, y|
      row.each_with_index do |col, x|
        if @cursor == [y, x]
          print " #{col} ".colorize(:background => :red)
        elsif x % 2 == y % 2
          print " #{col} ".colorize(:background => :light_blue)
        else
          print " #{col} ".colorize(:background => :blue)
        end
      end
      puts ""
    end
  end



  def read_char
  STDIN.echo = false
  STDIN.raw!

  input = STDIN.getc.chr
  if input == "\e" then
    input << STDIN.read_nonblock(3) rescue nil
    input << STDIN.read_nonblock(2) rescue nil
  end
ensure
  STDIN.echo = true
  STDIN.cooked!

  return input
end

# oringal case statement from:
# http://www.alecjacobson.com/weblog/?p=75
def show_single_key
  system('clear')
  render

  while @board.end_pos.nil?
    c = read_char

    case c
    when "\r"
      if @board.start.nil?
        @board.start = @cursor.dup
      elsif @cursor != @board.start
        @board.end_pos = @cursor.dup
        @board.move
        @board.start = nil
        @board.end_pos = nil
        # system('clear')
        render
      else
        @board.start = nil
      end


      #set start and end cursor positions
      #puts "RETURN"
    when "\e[A"
      @cursor[0] -= 1 unless @cursor[0].zero?
      system('clear')
      render
      #puts "UP ARROW"
    when "\e[B"
      @cursor[0] += 1 unless @cursor[0] == 7
      system('clear')
      render
      #puts "DOWN ARROW"
    when "\e[C"
      @cursor[1] += 1 unless @cursor[1] == 7
      system('clear')
      render
      #puts "RIGHT ARROW"
    when "\e[D"
      @cursor[1] -= 1 unless @cursor[1].zero?
      system('clear')
      render
      #puts "LEFT ARROW"
    when "\u0003"
      puts "CONTROL-C"
      break
      #puts "SOMETHING ELSE: #{c.inspect}"
    end
  end
end

#show_single_key while(true)


end
