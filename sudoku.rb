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
        # Store known squares with their values and unknown squares with digits
        # For ex : if a given puzzle is  "1-58-2----9--764-52--4--819-19--73-6762-83-9-----61-5---76---3-43--2-5-16--3-89--"
        # values = {"A1"=>"1", "A2"=>"123456789", "A3"=>"5", ...}
        values = squares.zip(puzzle.split("").map{|c| c.sub(/[0.-]/, digits)}).to_h
        # Assign the already solved squares to values hash.
        values.each {|k, v| assign(values, k, v) if v.length == 1}
    end

    def assign(values, s, d)
        values[s] = d # Assign a digit (d) to a square (s)
        # Eliminate digit d from square's peers, return false if condradiction is detected
        peers[s].each.all?{|ps| eliminate(values, ps, d)} ? values : false
    end

    def eliminate(values, s, d)
        # Return values if already eliminated (Base case)
        return values if !values[s].include?(d)
        values[s] = values[s].sub(d, '') # Eliminate a digit
        return false if values[s].length == 0 # Contradiction: removed last value, return false

        if values[s].length == 1 # If a square has only 1 digit left, assign it there
            return false unless assign(values, s, values[s])
        end

        # If a unit u is reduced to only one place for a value d, then put it there.
        units[s].each do |unit|
            dplaces = []
            unit.each { |u| dplaces << u if values[u].include?(d)}
            return false if dplaces.length == 0 # Contradiction: no place for this value
            if dplaces.length == 1
                # d can only be in one place in unit; assign it there
                return false unless assign(values, dplaces[0], d)
            end
        end
        return values
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