module Helper
    def self.cross_prod(a, b)
        squares = []
        a.chars{|i| b.chars {|j| squares << i + j}}
        return squares
    end

    def self.group_grid
        col_indentifiers = ["123","456","789"]
        row_identifiers = ["ABC","DEF","GHI"]
        grids = row_identifiers.each.map {|row| col_indentifiers.each.map{|int| [row, int]}}.flatten(1)
    end

    def self.unit_list(rows, cols)
        cols.chars.map{|c| cross_prod(rows, c)} + 
        rows.chars.map{|r| cross_prod(r, cols)} +
        group_grid().map{|g| cross_prod(g[0], g[1])}
    end

    def self.units(squares, unit_list)
        units = {}
        squares.each do |s|
            units[s] = unit_list.select{|u| u.include?(s)}
        end
        return units
    end

    def self.peers(squares, units)
        peers = {}
        squares.each do |s|
            peers[s] = units[s].flatten.uniq.reject{|k| k == s}
        end
        return peers
    end
end

class Sudoku
    attr_accessor :puzzle
    attr_reader :digits, :rows, :cols, :squares, :unit_list, :units, :peers
    def initialize
        @digits = "123456789"
        @rows   = "ABCDEFGHI"
        @cols   = @digits
        @squares = Helper.cross_prod(@rows, @cols)
        @unit_list = Helper.unit_list(@rows, @cols)
        @units = Helper.units(@squares, @unit_list)
        @peers = Helper.peers(@squares, @units)
        @puzzle = ""
    end

    def parse_grid
    end

    def assign(values, s, d)
    end

    def eliminate(values, s, d)
    end

    def search(values)
    end

    # Starts here
    # Call parse_grid method first to eliminate values, then call search function
    def solve
        solved = search(parse_grid())
        if solved 
             # Add it to puzzle instace variable if solved
            return self.puzzle = solved
        end
        return nil # Can't solve this puzzle
    end

    def to_s
        output = ""
        puzzle.each_char.with_index do |s, i|
          s = "-" if s.match(/[0.-]/)
          formatter = "#{s} "
          formatter = "#{s} | " if (i + 1) % 3 == 0
          formatter = "#{s}\n" if (i + 1) % 9 == 0
          formatter += "#{"-" * 21}\n" if (i + 1) % 27 == 0 && i != 80
          output += formatter 
        end
        return output + "\n"
    end
end

puzzle = "1-58-2----9--764-52--4--819-19--73-6762-83-9-----61-5---76---3-43--2-5-16--3-89--"
sudoku = Sudoku.new()


sudoku.puzzle = puzzle
puts sudoku