require './pieces/piece'

class Kei < Piece
  def move? before, after
    if @grow == true
      return move_kin before, after
    end

    return true if before[0]  == after[0] && before[1]  == after[1]
    if @player == :first
      return true if before[0]-1 == after[0] && before[1]-2 == after[1]
      return true if before[0]+1 == after[0] && before[1]-2 == after[1]
    else
      return true if before[0]-1 == after[0] && before[1]+2 == after[1]
      return true if before[0]+1 == after[0] && before[1]+2 == after[1]
    end
    false
  end

  def to_s
    disp "桂"
  end

  def can_next? pos
    return true if @grow == true
    if @player == :first
      return false if pos[1] <= 1
    else
      return false if pos[1] >= 7
    end
  end
end
