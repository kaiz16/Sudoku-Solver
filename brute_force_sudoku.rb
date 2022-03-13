class Sudoku
    attr_accessor :game_board, :backtrack_count
    attr_reader :initial_board
    def initialize(board_string)
      @initial_board = board_string
      @game_board = []
      row = []
      board_string.each_char.with_index do |number, index|
          row << number.to_i
          if (index + 1) % 9 == 0
              @game_board << row
              row = [] 
          end
      end
      @backtrack_count = 0
    end

    def solve
        return true if finished?
        empty = find_empty()
        row = empty[0]
        col = empty[1]
        (1..9).each do |num|
            if is_safe(row, col, num)
                game_board[row][col] = num
                return true if solve()
            end
        end
        self.backtrack_count += 1
        game_board[row][col] = 0
        return false
    end

    def find_empty
        game_board.each_with_index do |row, row_index|
            row.each_with_index do |col, col_index|
              if col == 0
                return [row_index, col_index]
              end
            end
          end
        return false
    end

    def is_safe(rowIndex, colIndex, number)
        return !find_row(rowIndex).include?(number) && !find_column(rowIndex, colIndex).include?(number) && !find_square(rowIndex, colIndex).include?(number)
    end

    def finished?
      return false if game_board.any?{|row| row.include?(0)}
      return true
    end
  
    def board
      initial_board
    end

    def find_row(rowIndex)
      game_board[rowIndex]
    end

    def find_column(rowIndex, colIndex, column = [])
      return column if column.length == 9
      column << game_board[rowIndex][colIndex]
          find_column(rowIndex - 1, colIndex, column) || 
          find_column(rowIndex + 1, colIndex, column)
    end

    def find_square(row_index, col_index)
      grid = []
      row = (row_index / 3) * 3
      col = (col_index / 3) * 3
      for i in row..row + 2
          for j in col..col + 2
            grid << game_board[i][j]
          end
      end
      return grid
    end

    def to_s
     output = "-" * 25 + "\n"
      game_board.each_with_index do |row, row_index|
          formatter = "| "
          row.each_with_index do |col, col_index|
              col = "-" if col == 0
              formatter += "#{col} "
              formatter += "| " if (col_index + 1) % 3 == 0
          end
         output += formatter + "\n"
         output += "-" * 25 + "\n" if (row_index + 1) % 3 == 0
      end
      return output
    end
end

puzzle = "8----------36------7--9-2---5---7-------457-----1---3---1----68--85---1--9----4--"
game = Sudoku.new(puzzle)
puts game
start = Time.now()
game.solve
finish = Time.now()
diff = finish - start
puts game
puts diff
p game.backtrack_count