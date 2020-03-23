require_relative 'sudoku'

GRID1 = '8----------36------7--9-2---5---7-------457-----1---3---1----68--85---1--9----4--'
GRID2 = '4.....8.5.3..........7......2.....6.....8.4......1.......6.3.7.5..2.....1.4......'
HARD  = '.....6....59.....82....8....45........3........6..3.54...325..6..................'
files = ['easiest_sudoku_puzzles.txt', 'easy_sudoku_puzzles.txt', '95_hard_puzzles.txt', 'all_17_clue_sudokus.txt']
sudoku = Sudoku.new()
start = Time.now()
files.each do |file|
    puts "Running " + file
    File.readlines("Puzzles/easiest_sudoku_puzzles.txt").each_with_index do |puzzle, line|
        puts "Puzzle #{line + 1} - #{puzzle.chomp}"
        sudoku.puzzle = puzzle.chomp
        sudoku.solve
        puts sudoku
    end
end
finish = Time.now()
diff = finish - start
puts diff