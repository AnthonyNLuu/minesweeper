class Minefield
  attr_reader :row_count, :column_count, :clicked, :full_board

  def initialize(row_count, column_count, mine_count)
    @column_count = column_count
    @row_count = row_count
    @clicked = []
    @mine_count = mine_count
    @mines = []
    @full_board = @mines + @clicked

    mine_count.times do
      mine = nil
      while !mine
        mine = [rand(row_count), rand(column_count)]
        if @mines.include?(mine)
          mine = nil
        else
          @mines << mine
        end
      end
    end
  end

  # Return true if the cell been uncovered, false otherwise.
  def cell_cleared?(row, col)
    @clicked.include?([row,col])
  end

  # Uncover the given cell. If there are no adjacent mines to this cell
  # it should also clear any adjacent cells as well. This is the action
  # when the player clicks on the cell.
  def clear(row, col)
    @clicked << [row,col] unless @clicked.include?([row, col])

    return false if @mines.include?([row, col])
    return true if adjacent_mines(row, col) > 0 # Base case. Cease execution if square is adjacent to mine.

    if adjacent_mines(row,col) == 0
      -1.upto(1) do |row_adjust|
        -1.upto(1) do |column_adust|

          adjusted_row = row + row_adjust
          adjusted_col = col + column_adust

          next if row_adjust == 0 && column_adust == 0
          next if adjusted_row < 0 || adjusted_col < 0
          next if adjusted_row > @row_count || adjusted_col > @column_count
          next if @clicked.include?([adjusted_row, adjusted_col])
          next if @mines.include?([adjusted_row, adjusted_col])

          @clicked << [adjusted_row,adjusted_col]

          if adjacent_mines(adjusted_row, adjusted_col) == 0
            clear(adjusted_row,adjusted_col)
          end

        end
      end
    end

  end

  # Check if any cells have been uncovered that also contained a mine. This is
  # the condition used to see if the player has lost the game.
  def any_mines_detonated?
    return false if @clicked[-1].nil?
    @mines.include?(@clicked[-1])
  end

  # Check if all cells that don't have mines have been uncovered. This is the
  # condition used to see if the player has won the game.
  def all_cells_cleared?
    @full_board = @clicked + @mines
    full_board.size == (@row_count+1) * (@column_count+1)
  end

  # Returns the number of mines that are surrounding this cell (maximum of 8).
  def adjacent_mines(row, col)
    adjacent_mine_count = 0

    -1.upto(1) do |row_adjust|
      -1.upto(1) do |column_adust|
        adjusted_col = col + column_adust
        adjusted_row = row + row_adjust
        next if row_adjust == 0 && column_adust == 0
        next if adjusted_row < 0 || adjusted_col < 0
        next if adjusted_row > @row_count || adjusted_col > @column_count
          if @mines.include?([(adjusted_row),(adjusted_col)])
            adjacent_mine_count+=1
          end
      end
    end
    adjacent_mine_count
  end

  # Returns true if the given cell contains a mine, false otherwise.
  def contains_mine?(row, col)
    @mines.include?([row,col])
  end
end
