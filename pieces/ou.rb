require './pieces/piece'

class Ou < Piece

  def move? before, after
    move_ou before, after
  end

  #TODO: 例外
  def grow status
  end

  def to_s
    if @player == :first
      "王"
    else
      "玉"
    end
  end
end
