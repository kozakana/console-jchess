require './common_move'

class Ou < Piece

  def move? before, after
    CommonMove.ou before, after
  end

  def disp
    if @player == :first
      "王"
    else
      "玉"
    end
  end
end
