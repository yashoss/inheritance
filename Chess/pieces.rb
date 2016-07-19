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

  # TODO: move to steppable
  def valid_moves(board, checking = false)
    val = []
    self.moves.each do |square|
      y = self.position[0] + square[0]
      x = self.position[1] + square[1]
      val << [y,x] unless x < 0 || x > 7 || y < 0 || y > 7 || self.color == board.grid[y][x].color
    end
    # require 'byebug'
    # debugger'

    # TODO: abstract to its own method
    unless checking
      val.deep_dup.each do |mov|
        copy = board.board_dup
        copy.start = self.position
        copy.end_pos = mov
        val.delete(mov) if copy.move2.in_check?(self.color)
      end
    end
    puts " here" if self.is_a?(Pawn)
    val
  end

end

class SlidingPiece < Piece

  # def initialize(color, symbol, position)
  #   super
  # end

end

class SteppingPiece < Piece

  # def initialize(color, symbol, position)
  #   super
  # end

end

class Rook < SlidingPiece

attr_reader :moves

  #TODO: replace with move diffs with just the four directions
  def initialize(color, symbol, position)
    @moves = []
     (-7..7).each do |num|
       @moves << [0,num]
       @moves << [num,0]
     end
     super
  end

  # TODO: move this to sliding piece
  # TODO: go through move_diffs until you hit an edge or piece
  # Replace four loops with "each" through the move diffs
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
      val << [y,x] unless x < 0 || x > 7 || y < 0 || y > 7 || self.color == board.grid[y][x].color
    end

    unless checking
      val.deep_dup.each do |mov|
        copy = board.board_dup
        copy.start = self.position
        copy.end_pos = mov
        val.delete(mov) if copy.move2.in_check?(self.color)
      end
    end
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
