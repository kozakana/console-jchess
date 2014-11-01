require './pieces/piece'

class Kin < Piece
  def kind
    :kin
  end

  def move? before, after
    move_kin before, after
  end

  #TODO: 例外
  def grow status
  end

  def to_s
    disp "金"
  end
end
