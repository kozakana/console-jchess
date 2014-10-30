# TODO: 強制的駒を成る判定(行ける所がない判定)
# TODO: 角の行けるところ判定
# TODO: 駒クラスに分けて行けるところ判定を駒クラスに入れる
#       initialize / == / to_s

class Piece
  attr_accessor :player, :grow
  attr_reader :kind
  
  # kindはいらないかも
  def initialize kind=nil, player=nil, grow=nil
    @kind   = kind
    @player = player
    @grow   = grow
  end

  def ==(pce)
    @kind == pce.kind && @player == pce.player
  end

  # 盤外かどうかのチェックはここでは無し
  def move? before, after
    p "未実装！"
  end

  def move_ou before, after
    return false unless before[0]-1 <= after[0] && after[0] <= before[0]+1
    return false unless before[1]-1 <= after[1] && after[1] <= before[1]+1
    true
  end

  def move_kin before, after
    return false unless move_ou before, after

    if @player == :first
      return false unless before[0]-1 == after[0] && before[1]-1 == after[1]
      return false unless before[0]+1 == after[0] && before[1]-1 == after[1]
    else
      return false unless before[0]-1 == after[0] && before[1]+1 == after[1]
      return false unless before[0]+1 == after[0] && before[1]+1 == after[1]
    end
    true
  end

  def move_hi before, after
    return true if before[0] == after[0]
    return true if before[1] == after[1]

    if @grow == true
      return move_ou before, after
    end
    
    return true if before[0] == after[0]

    false
  end
  
  # それぞれのクラスで実装
  def to_s
  end

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

  # 次動ける場所かどうか(駒を打つ時の判定等)
  def can_next? pos
    true
  end
end
