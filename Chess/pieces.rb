require 'singleton'

class Piece

  attr_reader :color, :symbol
  attr_accessor :position

  def initialize(color, symbol, position)
    @color = color
    @symbol = symbol
    @position = position
  end

  def move
  end

  def to_s()
    @symbol
  end

  def valid_moves(board, checking = false)
    val = []
    self.moves.each do |square|
      y = self.position[0] + square[0]
      x = self.position[1] + square[1]
      val << [y,x] unless x < 0 || x > 7 || y < 0 || y > 7 || self.color == board.grid[y][x].color
    end
    # require 'byebug'
    # debugger'
    unless checking
      val.deep_dup.each do |mov|
        copy = board.board_dup
        copy.start = self.position
        copy.end_pos = mov
        val.delete(mov) if copy.move2.in_check?(self.color)
      end
    end
    p val, self.symbol, self.position if self.is_a?(Pawn)
    val
  end

end

class SlidingPiece < Piece

  def initialize(color, symbol, position)
    super
  end

end

class SteppingPiece < Piece

  def initialize(color, symbol, position)
    super
  end

end

class Rook < SlidingPiece

attr_reader :moves

  def initialize(color, symbol, positon)
    @moves = []
     (-7..7).each do |num|
       @moves << [0,num]
       @moves << [num,0]
     end
     super
  end

  def valid_moves(board, checking = false)
    unblock = []
    #checking Down
    (1..7).each do |num|
      y = self.position[0] + num
      x = self.position[1]
      break if x < 0 || x > 7 || y < 0 || y > 7
      unblock << [y, x] unless self.color == board.grid[y][x].color
      break unless board.grid[y][x].is_a?(NullPiece)
    end

    #checking Up
    (1..7).each do |num|
      y = self.position[0] - num
      x = self.position[1]
      break if x < 0 || x > 7 || y < 0 || y > 7
      unblock << [y, x] unless self.color == board.grid[y][x].color
      break unless board.grid[y][x].is_a?(NullPiece)
    end

    #checking Right
    (1..7).each do |num|
      y = self.position[0]
      x = self.position[1] + num
      break if x < 0 || x > 7 || y < 0 || y > 7
      unblock << [y, x] unless self.color == board.grid[y][x].color
      break unless board.grid[y][x].is_a?(NullPiece)
    end

    (1..7).each do |num|
      y = self.position[0]
      x = self.position[1] - num
      break if x < 0 || x > 7 || y < 0 || y > 7
      unblock << [y, x] unless self.color == board.grid[y][x].color
      break unless board.grid[y][x].is_a?(NullPiece)
    end

    unless checking
      unblock.deep_dup.each do |mov|
        copy = board.board_dup
        copy.start = self.position
        copy.end_pos = mov
        unblock.delete(mov) if copy.move2.in_check?(self.color)
      end
    end
    unblock

  end



end

class Bishop < SlidingPiece

attr_reader :moves

  def initialize(color, symbol, position)
    @moves = []
      (-7..7).each do |num|
        @moves << [num,num]
        @moves << [-num,num]
      end
    super
  end
end

  def valid_moves(board, checking = false)
    (1..7).each do |num|
      y = self.position[0] + num
      x = self.position[1] + num
      break if x < 0 || x > 7 || y < 0 || y > 7
      unblock << [y, x] unless self.color == board.grid[y][x].color
      break unless board.grid[y][x].is_a?(NullPiece)
    end

    (1..7).each do |num|
      y = self.position[0] - num
      x = self.position[1] - num
      break if x < 0 || x > 7 || y < 0 || y > 7
      unblock << [y, x] unless self.color == board.grid[y][x].color
      break unless board.grid[y][x].is_a?(NullPiece)
    end

    (1..7).each do |num|
      y = self.position[0] - num
      x = self.position[1] + num
      break if x < 0 || x > 7 || y < 0 || y > 7
      unblock << [y, x] unless self.color == board.grid[y][x].color
      break unless board.grid[y][x].is_a?(NullPiece)
    end

    (1..7).each do |num|
      y = self.position[0] + num
      x = self.position[1] - num
      break if x < 0 || x > 7 || y < 0 || y > 7
      unblock << [y, x] unless self.color == board.grid[y][x].color
      break unless board.grid[y][x].is_a?(NullPiece)
    end

    unless checking
      unblock.deep_dup.each do |mov|
        copy = board.board_dup
        copy.start = self.position
        copy.end_pos = mov
        unblock.delete(mov) if copy.move2.in_check?(self.color)
      end
    end
    unblock

  end

class Queen < SlidingPiece

attr_reader :moves

  def initialize(color, symbol, position)
    @moves = []
      (-7..7).each do |num|
        @moves << [0,num]
        @moves << [num,0]
        @moves << [num,num]
        @moves << [-num,num]
      end
    super
  end

  def valid_moves(board, checking = false)
    unblock = []

    (1..7).each do |num|
      y = self.position[0] + num
      x = self.position[1] + num
      break if x < 0 || x > 7 || y < 0 || y > 7
      unblock << [y, x] unless self.color == board.grid[y][x].color
      break unless board.grid[y][x].is_a?(NullPiece)
    end

    (1..7).each do |num|
      y = self.position[0] - num
      x = self.position[1] - num
      break if x < 0 || x > 7 || y < 0 || y > 7
      unblock << [y, x] unless self.color == board.grid[y][x].color
      break unless board.grid[y][x].is_a?(NullPiece)
    end

    (1..7).each do |num|
      y = self.position[0] - num
      x = self.position[1] + num
      break if x < 0 || x > 7 || y < 0 || y > 7
      unblock << [y, x] unless self.color == board.grid[y][x].color
      break unless board.grid[y][x].is_a?(NullPiece)
    end

    (1..7).each do |num|
      y = self.position[0] + num
      x = self.position[1] - num
      break if x < 0 || x > 7 || y < 0 || y > 7
      unblock << [y, x] unless self.color == board.grid[y][x].color
      break unless board.grid[y][x].is_a?(NullPiece)
    end

    (1..7).each do |num|
      y = self.position[0] + num
      x = self.position[1]
      break if x < 0 || x > 7 || y < 0 || y > 7
      unblock << [y, x] unless self.color == board.grid[y][x].color
      break unless board.grid[y][x].is_a?(NullPiece)
    end

    #checking Down
    (1..7).each do |num|
      y = self.position[0] - num
      x = self.position[1]
      break if x < 0 || x > 7 || y < 0 || y > 7
      unblock << [y, x] unless self.color == board.grid[y][x].color
      break unless board.grid[y][x].is_a?(NullPiece)
    end

    #checking Right
    (1..7).each do |num|
      y = self.position[0]
      x = self.position[1] + num
      break if x < 0 || x > 7 || y < 0 || y > 7
      unblock << [y, x] unless self.color == board.grid[y][x].color
      break unless board.grid[y][x].is_a?(NullPiece)
    end

    (1..7).each do |num|
      y = self.position[0]
      x = self.position[1] - num
      break if x < 0 || x > 7 || y < 0 || y > 7
      unblock << [y, x] unless self.color == board.grid[y][x].color
      break unless board.grid[y][x].is_a?(NullPiece)
    end

    unless checking
      unblock.deep_dup.each do |mov|
        copy = board.board_dup
        copy.start = self.position
        copy.end_pos = mov
        unblock.delete(mov) if copy.move2.in_check?(self.color)
      end
    end
    unblock
  end

end

class Knight < SteppingPiece

attr_reader :moves

  def initialize(color, symbol, position)
    @moves = [[2,1], [1,2], [-1,-2], [-1,2], [1,-2], [2,-1], [-2,1], [-2,-1]]
    super
  end

end

class King < SteppingPiece

attr_reader :moves

  def initialize(color, symbol, position)
    @moves = [[1,1], [0,1], [1,0], [-1,-1], [-1,0], [0,-1], [-1,1], [1,-1]]
    super

  end

end

class Pawn < Piece

attr_reader :moves

  def initialize(color, symbol, position)
    @moves = [[1,1], [0,1], [1,0], [-1,-1], [-1,0], [0,-1], [-1,1], [1,-1],
              [2,0], [-2,0]]
    super
  end



end

class NullPiece
  include Singleton

  def moves()
  end

  def color()
  end

  def to_s()
    " "
  end

  def empty?()
    true
  end

end
