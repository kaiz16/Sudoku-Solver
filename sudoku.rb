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
    attr_reader :digits, :rows, :cols, :squares, :unit_list, :units, :peers
    def initialize
        @digits = "123456789"
        @rows   = "ABCDEFGHI"
        @cols   = @digits
        @squares = Helper.cross_prod(@rows, @cols)
        @unit_list = Helper.unit_list(@rows, @cols)
        @units = Helper.units(@squares, @unit_list)
        @peers = Helper.peers(@squares, @units)
    end

end

game = Sudoku.new()
game.test