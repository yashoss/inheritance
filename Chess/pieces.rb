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

    # TODO: abstract to its own method
  def no_check_moves(val, board)
      val.deep_dup.each do |mov|
        copy = board.board_dup
        copy.start = self.position
        copy.end_pos = mov
        val.delete(mov) if copy.move2.in_check?(self.color)
      end
    val
  end

  def out_of_range?(y, x)
    x < 0 || x > 7 || y < 0 || y > 7
  end

end

class SlidingPiece < Piece
 #Ducky
 def valid_moves(board, checking = false)
   unblock = []
   self.direction.each do |dir|
     y = self.position[0]
     x = self.position[1]
     7.times do
       y += dir[0]
       x += dir[1]
       break if out_of_range?(y,x)
       unblock << [y, x] unless self.color == board.grid[y][x].color
       break unless board.grid[y][x].is_a?(NullPiece)
     end
   end
   unblock == no_check_moves(unblock, board) unless checking
   unblock
 end

end

class SteppingPiece < Piece

  def valid_moves(board, checking = false)
    val = []
    self.moves.each do |square|
      y = self.position[0] + square[0]
      x = self.position[1] + square[1]
      val << [y,x] unless out_of_range?(y,x) || self.color == board.grid[y][x].color
    end
    val = no_check_moves(val, board) unless checking
    val
  end

end

class Rook < SlidingPiece

  attr_reader :moves, :direction


  #TODO: replace with move diffs with just the four directions
  def initialize(color, symbol, position)
    @direction = [[1,0],[-1,0],[0,1],[0,-1]]
    super
  end
end

class Bishop < SlidingPiece

attr_reader :moves, :direction

  def initialize(color, symbol, position)
    @direction = [[1,1],[1,-1],[-1,1],[-1,-1]]
    super
  end

end

class Queen < SlidingPiece

attr_reader :moves, :direction

  def initialize(color, symbol, position)
    @direction = [[1,1],[1,-1],[-1,1],[-1,-1],[1,0],[-1,0],[0,1],[0,-1]]
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
    @moves = [[1,1], [1,0], [-1,-1], [-1,0], [-1,1], [1,-1],
              [2,0], [-2,0]]
    super
  end

  # TODO: break into check_capture, check_first_move, check_collison
  def valid_moves(board, checking = false)

    @moves = [[1,1], [1,0], [-1,-1], [-1,0], [-1,1], [1,-1],
              [2,0], [-2,0]]

    if self.color == 'black'
      y = self.position[0]
      x = self.position[1]

      @moves.reject! { |move| move[0] == -1 || move[0] == -2}
      if y + 2 > 7 || self.position[0] != 1 || !board.grid[y+2][x].is_a?(NullPiece) || !board.grid[y+1][x].is_a?(NullPiece)
        @moves.delete([2,0])
      end

      if y + 1 > 7 || !board.grid[y+1][x].is_a?(NullPiece)
        @moves.delete([1,0])
      end

      if board.grid[y+1][x+1].nil? || !board.grid[y+1][x+1].color == 'white' || board.grid[y+1][x+1].is_a?(NullPiece)
        @moves.delete([1,1])
      end

      if board.grid[y+1][x-1].nil? || !board.grid[y+1][x-1].color == 'white' || board.grid[y+1][x-1].is_a?(NullPiece)
        @moves.delete([1,-1])
      end
    else
      y = self.position[0]
      x = self.position[1]

      @moves.reject! { |move| move[0] == 1 || move[0] == 2}
      if y - 2 < 0 || self.position[0] != 6 || !board.grid[y-2][x].is_a?(NullPiece) || !board.grid[y-1][x].is_a?(NullPiece)
        @moves.delete([-2,0])
      end

      if y - 1 < 0 || !board.grid[y-1][x].is_a?(NullPiece)
        @moves.delete([-1,0])
      end

      if board.grid[y-1][x-1].nil? || !board.grid[y-1][x-1].color == 'black' || board.grid[y-1][x-1].is_a?(NullPiece)
        @moves.delete([-1,-1])
      end

      if board.grid[y-1][x+1].nil? || !board.grid[y-1][x+1].color == 'black' || board.grid[y-1][x+1].is_a?(NullPiece)
        @moves.delete([-1,1])
      end
    end

    val = []
    self.moves.each do |square|
      y = self.position[0] + square[0]
      x = self.position[1] + square[1]
      val << [y,x] unless out_of_range?(y,x) || self.color == board.grid[y][x].color
    end

    val = no_check_moves(val, board) unless checking
    val
  end

end

class NullPiece
  include Singleton

  def moves()
  end

  def color()
    nil
  end

  def to_s()
    " "
  end

  def empty?()
    true
  end

end
