# TODO: 強制的駒を成る判定(行ける所がない判定)
# TODO: 駒クラスに分けて行けるところ判定を駒クラスに入れる
#       initialize / == / to_s

class Piece
  attr_accessor :player, :grow
  
  def initialize player=nil, grow=nil
    @player = player
    @grow   = grow
  end

  def kind
    raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def ==(pce)
    @player == pce.player
  end

  # 盤外かどうかのチェックはここでは無し
  def move? before, after
    raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  # それぞれのクラスで実装
  def to_s
    raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end
  
  private

  def disp pce
    str = ""
    if @player == :first
      str += "\e[32m"
    else
      str += "\e[31m"
    end

    if @grow == true
      str += "*"
    else
      str += " "
    end
    str += pce
    str += "\e[0m"
    str
  end

  def move_ou before, after
    return false unless before[0]-1 <= after[0] && after[0] <= before[0]+1
    return false unless before[1]-1 <= after[1] && after[1] <= before[1]+1
    true
  end

  def move_kin before, after
    return false unless move_ou before, after
    
    if @player == :first
      return false if before[0]-1 == after[0] && before[1]+1 == after[1]
      return false if before[0]+1 == after[0] && before[1]+1 == after[1]
    else
      return false if before[0]-1 == after[0] && before[1]-1 == after[1]
      return false if before[0]+1 == after[0] && before[1]-1 == after[1]
    end
    true
  end
end
