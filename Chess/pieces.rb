require 'singleton'

class Piece

  attr_reader :color
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

  def self.valid_moves(grid)
    val = []
    self.class.moves.each do |square|
      y = self.position[0] + square[0]
      x = self.position[1] + square[1]
      val << [y,x] unless x < 0 || x > 7 || y < 0 || y > 7 || self.color == grid[y][x].color
    end

    val.each do |mov|
      board.start = self.position
      board.end_pos = mov
      val.delete(mov) if board.move.in_check?(self.color)
    end
    val
  end

end

class SlidingPiece < Piece

  def initialize(color, symbol, postion)
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
