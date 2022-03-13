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
    attr_accessor :values
    attr_reader :digits, :rows, :cols, :squares, :unit_list, :units, :peers#, :values
    def initialize
        @digits = "123456789"
        @rows   = "ABCDEFGHI"
        @cols   = @digits
        @squares = Helper.cross_prod(@rows, @cols)
        @unit_list = Helper.unit_list(@rows, @cols)
        @units = Helper.units(@squares, @unit_list)
        @peers = Helper.peers(@squares, @units)
        #@values = squares.zip(board_string.split("").map{|c| c.sub(/[0.-]/, @digits)}).to_h
       # p @initial_puzzle
    end

    def eliminate(val)
        solved_squares = squares.select{|s| val[s].length == 1}
        solved_squares.each do |s|
            peers[s].each do |k| 
                    val[k] = val[k].sub(val[s], '')
            end
        end
       if squares.any?{|k| val[k].length == 0}
        return false 
       end
       only_choice(val)
    end

    def only_choice(val)
        #return false if !val
        unit_list.each do |unit|
           digits.each_char do |d|
            dplaces = []
            unit.each{|box| dplaces << box if val[box].include?(d)}
            val[dplaces[0]] = d if dplaces.length == 1
           end
        end
        return val
    end

    def reduce(val, old_values = [])
        return false unless val
        return val if old_values == val
        old_values = val.dup()
        val = eliminate(val)
        reduce(val, old_values)
    end

    def solve(board_string)
        values = squares.zip(board_string.split("").map{|c| c.sub(/[0.-]/, digits)}).to_h
        #solved = search(values)
        solved = search(reduce(values))
        puts display(solved)
    end

    def search(values)
     
        return false if !values
        return p values if squares.all?{|s| values[s].length == 1} # Solved! Yay
 
        s = values.key(values.each_value.select{|s| s if s.length > 1}.min_by(&:length))
        values[s].each_char do |d|
            attempt_values = values.dup()
            attempt_values[s] = d
            r = search(reduce(attempt_values))
            return r if r
          end
          return false
      end
      
    def display(values)
        output = ""
        values.values.each.with_index do |s, i|
          formatter = "#{s} "
          formatter = "0 " if s.length == 0
          formatter = "#{s}\n" if (i + 1) % 9 == 0
          output += formatter
        end
        return output
    end
end
#puzzle = "---------------------------------------------------------------------------------"
puzzle = "8----------36------7--9-2---5---7-------457-----1---3---1----68--85---1--9----4--"
#puzzle = "1-58-2----9--764-52--4--819-19--73-6762-83-9-----61-5---76---3-43--2-5-16--3-89--"
# puzzle = "000000012000035000000600070700000300000400800100000000000120000080000040050000600"

game = Sudoku.new()
game.solve(puzzle)
# start = Time.now()
# board_string = File.readlines('all_17_clue_sudokus.txt')
# board_string.each_with_index do |i, y|
#     puzzle = i.chomp
# 	p "#{y + 1} Sudoku input: " + puzzle
	
# 	game.solve(puzzle)
# end
# finish = Time.now()
# diff = finish - start
# puts diff
#0.222343584