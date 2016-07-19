require 'io/console'

module Cursorable

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

  def select(color)
    system('clear')
    render
    @board.start = nil
    @board.end_pos = nil
    while @board.end_pos.nil?
      c = read_char

      case c
      when "\r"
        if @board.start.nil? && @board.grid[@cursor[0]][@cursor[1]].color == color && !@board.grid[@cursor[0]][@cursor[1]].is_a?(NullPiece)
          @board.start = @cursor.dup
        elsif !@board.start.nil? && @cursor != @board.start
          @board.end_pos = @cursor.dup
          @board.move
          system('clear')
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
        exit
        #puts "SOMETHING ELSE: #{c.inspect}"
      end
    end
  end

  #show_single_key while(true)
end
