require './common_move'

class Kin < Piece
  def move? before, after
    return false unless CommonMove.ou before, after

    if @player == :first
      return false unless before[0]-1 == after[0] && before[1]-1 == after[1]
      return false unless before[0]+1 == after[0] && before[1]-1 == after[1]
    else
      return false unless before[0]-1 == after[0] && before[1]+1 == after[1]
      return false unless before[0]+1 == after[0] && before[1]+1 == after[1]
    end
    true
  end
end
