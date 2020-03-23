# Sudoku Solver based on Peter Norvig's Implementation

## PC Specs

* **CPU** - Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz (3.80GHz Boost) 4 Cores 8 Threads 
* **iGPU** - Intel® HD Graphics 630
* **GPU** - GTX 1050 (Not in use while running benchmark)
* **RAM** - 12 GB
* **OS** - elementary OS 5.1 Hera

### Benchmark

> easiest 15 puzzles - 0.056925135 (secs)

> easy 10000 puzzles - 41.765237048 (secs)

> hard 95 puzzles - 2.5015151 (secs)

> all 17 clue sudokus - 483.013880786 (secs)

> Single GRID1 - 0.25 seconds

> Single GRID2 - 0.01 seconds

> Single HARD - 99.865432126 seconds

*Note that this was run while no other apps were opened except vscode.*

----
## Some notes on HARD puzzle
   
    HARD  = '.....6....59.....82....8....45........3........6..3.54...325..6..................'
    - - - | - - 6 | - - -
    - 5 9 | - - - | - - 8
    2 - - | - - 8 | - - -
    ---------------------
    - 4 5 | - - - | - - -
    - - 3 | - - - | - - -
    - - 6 | - - 3 | - 5 4
    ---------------------
    - - - | 3 2 5 | - - 6
    - - - | - - - | - - -
    - - - | - - - | - - -

    sudoku.puzzle = HARD
    sudoku.solve

    4 3 8 | 7 9 6 | 2 1 5
    6 5 9 | 1 3 2 | 4 7 8
    2 7 1 | 4 5 8 | 6 9 3
    ---------------------
    8 4 5 | 2 1 9 | 3 6 7
    7 1 3 | 5 6 4 | 8 2 9
    9 2 6 | 8 7 3 | 1 5 4
    ---------------------
    1 9 4 | 3 2 5 | 7 8 6
    3 6 2 | 9 8 7 | 5 4 1
    5 8 7 | 6 4 1 | 9 3 2

    99.865432126 seconds
 
 This puzzle alone takes longer than 95 hard puzzles solved altogether. You can learn more why this puzzle took so long by reading Peter Norvig's explanation below.
 > Unfortunately, this is not a true Sudoku puzzle because it has multiple solutions. (It was generated before I incorporated Olivier Grégoire's suggestion about checking for 8 digits, so note that any solution to this puzzle leads to another solution where the 1s and 7s are swapped.) But is this an intrinsicly hard puzzle? Or is the difficulty an artifact of the particular variable- and value-ordering scheme used by my search routine? To test I randomized the value ordering (I changed for d in values[s] in the last line of search to be for d in shuffled(values[s]) and implemented shuffled using random.shuffle). The results were starkly bimodal: in 27 out of 30 trials the puzzle took less than 0.02 seconds, while each of the other 3 trials took just about 190 seconds (about 10,000 times longer). There are multiple solutions to this puzzle, and the randomized search found 13 different solutions. My guess is that somewhere early in the search there is a sequence of squares (probably two) such that if we choose the exact wrong combination of values to fill the squares, it takes about 190 seconds to discover that there is a contradiction. But if we make any other choice, we very quickly either find a solution or find a contradiction and move on to another choice. So the speed of the algorithm is determined by whether it can avoid the deadly combination of value choices.

----
## Trying it out
* Clone this repo
* Run the command below

      ruby runner.rb


----
## Resources
* [Solving Every Sudoku Puzzles by Peter Norvig](https://norvig.com/sudoku.html)
* [Medium article explaining Norvig's code](https://medium.com/activating-robotic-minds/peter-norvigs-sudoku-solver-25779bb349ce)
* [The fastest sudoku solver](https://codegolf.stackexchange.com/questions/190727/the-fastest-sudoku-solver)