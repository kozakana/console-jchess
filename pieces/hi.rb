require './pieces/piece'

class Hi < Piece
  def move? before, after
    return true if before[0] == after[0]
    return true if before[1] == after[1]

    if @grow == true
      return move_ou before, after
    end
    
    false
  end

  def to_s
    disp "飛"
  end
end
