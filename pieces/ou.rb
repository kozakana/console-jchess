require './pieces/piece'

class Ou < Piece
  def kind
    :ou
  end

  def move? before, after
    move_ou before, after
  end

  #TODO: 例外
  def grow status
  end

  def to_s
    if @player == :first
      disp "王"
    else
      disp "玉"
    end
  end
end
