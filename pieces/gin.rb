require './pieces/piece'

class Gin < Piece
  def kind
    :gin
  end

  def move? before, after
    if @grow == true
      return move_kin before, after
    end
    
    return false unless move_ou before, after

    # 銀の横腹チェック
    return false if before[0]-1 == after[0] && before[1] == after[1]
    return false if before[0]+1 == after[0] && before[1] == after[1]

    if @player == :first
      return false if before[0] == after[0] && before[1]+1 == after[1]
    else
      return false if before[0] == after[0] && before[1]-1 == after[1]
    end
    true
  end

  def to_s
    disp "銀"
  end
end
