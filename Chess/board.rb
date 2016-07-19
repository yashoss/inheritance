require_relative 'pieces'

class Board

  attr_accessor :grid, :start, :end_pos

   def initialize
     @grid = Array.new(8) {Array.new(8, nil)}
     populate
     @start = nil
     @end_pos = nil
   end

   def move
     raise "No piece at #{@start}" if @grid[@start[0]][@start[1]].is_a?(NullPiece)
       if @grid[@start[0]][@start[1]].valid_moves(self).include?(@end_pos)
         @grid[@end_pos[0]][@end_pos[1]] = @grid[@start[0]][@start[1]]
         @grid[@end_pos[0]][@end_pos[1]].position = @end_pos
         @grid[@start[0]][@start[1]] = NullPiece.instance
       else
         @start = nil
         @end_pos = nil
       end

   end

   def move2
     @grid[@end_pos[0]][@end_pos[1]] = @grid[@start[0]][@start[1]]
     @grid[@end_pos[0]][@end_pos[1]].position = @end_pos
     @grid[@start[0]][@start[1]] = NullPiece.instance
     self
   end

   def [](pos)
     x, y = pos
     @grid[x][y]
   end

   def []=(pos, value)
     @grid[*pos] = value
   end

   def populate

     @grid[0][0], @grid[0][7] = Rook.new('black',"\u265C", [0,0]), Rook.new('black',"\u265C", [0,7])
     @grid[0][1], @grid[0][6] = Knight.new('black',"\u265E", [0,1]), Knight.new('black',"\u265E", [0,6])
     @grid[0][2], @grid[0][5] = Bishop.new('black', "\u265D", [0,2]), Bishop.new('black', "\u265D", [0,5])
     @grid[0][3] = Queen.new('black', "\u265B", [0,3])
     @grid[0][4] = King.new('black', "\u265A", [0,4])
     (0..7).each do |num|
       @grid[1][num] = Pawn.new('black', "\u265F", [1,num])
     end

     @grid[7][0], @grid[7][7] = Rook.new('white',"\u2656", [7,0]), Rook.new('white',"\u2656", [7,7])
     @grid[7][1], @grid[7][6] = Knight.new('white',"\u2658", [7,1]), Knight.new('white',"\u2658", [7,6])
     @grid[7][2], @grid[7][5] = Bishop.new('white', "\u2657", [7,2]), Bishop.new('white', "\u2657", [7,5])
     @grid[7][3] = Queen.new('white', "\u2655", [7,3])
     @grid[7][4] = King.new('white', "\u2654", [7,4])
     (0..7).each do |num|
       @grid[6][num] = Pawn.new('white', "\u2659", [6,num])
     end

     (2..5).each do |row|
       (0..7).each do |col|
         @grid[row][col] = NullPiece.instance
       end
     end

   end

   def in_check?(color)
     return false if self.is_a?(NullPiece)
     king = []
     @grid.each_with_index do |row, y|
       row.each_with_index do |col, x|
         if col.is_a?(King) && col.color == color
           king = [y,x]
           break
         end
       end
     end

     if color == "white"
       oppo_color = "black"
     else
       oppo_color = "white"
     end

     @grid.each do |row|
       row.each do |col|
         return true if col.color == oppo_color && col.valid_moves(self).include?(king)
        end
     end
     false
   end

   def checkmate?(color)
     dub = @grid.deep_dup
     @grid.each_with_index do |row, y|
       row.each_with_index do |col, x|
        if col.color == color
          col.valid_moves.each do |try|
            dub.start = [y,x]
            dub.end_pos = try
            dub.move
            return false unless dub.in_check?(color)
          end
        end
       end
     end
     true

   end


   def board_dup
     copy = Board.new
     self.grid.each_with_index do |row, y|
       row.each_with_index do |col, x|
         if col.is_a?(NullPiece)
           copy.grid[y][x] = NullPiece.instance
         else
           copy.grid[y][x] = col.class.new(col.color, col.symbol, col.position)
         end
       end
     end
     copy
   end

end #board class

class Array
  def deep_dup
    new_array = []
    each do |el|
      new_array << (el.is_a?(Array) ? el.deep_dup : el)
    end
    new_array
  end

end
