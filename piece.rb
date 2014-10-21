# TODO: 強制的駒を成る判定(行ける所がない判定)

class Piece
  attr_accessor :player, :grow
  attr_reader :kind

  def initialize kind=nil, player=nil, grow=nil
    @kind   = kind
    @player = player
    @grow   = grow
  end

  def ==(pce)
    @kind == pce.kind && @player == pce.player
  end

  def disp_kind kind
    case kind
    when :ou
      if @player == :first
        "王"
      else
        "玉"
      end
    when :kin
      "金"
    when :gin
      "銀"
    when :kei
      "桂"
    when :kyo
      "香"
    when :fu
      "歩"
    when :hi
      "飛"
    when :kaku
      "角"
    else
      "  "
    end
  end

  # 盤外かどうかのチェックはここでは無し
  # TODO
  def move? before, after
    case @kind
    when :ou
      move_ou before, after
    when :kin
      move_kin before, after
    when :gin
      move_gin before, after
    when :kei
      move_kei before, after
    when :kyo
      move_kyo before, after
    when :fu
      move_fu before, after
    when :hi
    when :kaku
    end
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

  def move_gin before, after
    return false unless move_ou before, after
    
    if @grow == true
      return move_kin before, after
    end

    # 銀の横腹チェック
    return false unless before[0]-1 == after[0] && before[1] == after[1]
    return false unless before[0]+1 == after[0] && before[1] == after[1]

    if @player == :first
      return false unless before[0] == after[0] && before[1]-1 == after[1]
    else
      return false unless before[0] == after[0] && before[1]+1 == after[1]
    end
    true
  end
  
  def move_kei before, after
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

  def move_kyo before, after
    if @grow == true
      return move_kin before, after
    end

    return true if before[0] == after[0]
    if @player == :first
      return false unless before[1] >= after[1]
    else
      return false unless before[1] <= after[1]
    end
    true
  end

  def move_fu
    if @grow == true
      return move_kin before, after
    end

    return true if before[0] == after[0]
    if @player == :first
      return true if before[0]-1 == after[0]
    else
      return true if before[0]+1 == after[0]
    end

    false
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

  def to_s
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
    str += disp_kind @kind
    str += "\e[0m"
    str
  end

  # 次動ける場所かどうか(駒を打つ時の判定等)
  def can_next? pos
    return true if @grow == true
    case @kind
    when :kei
      if @player == :first
        return false if pos[1] <= 1
      else
        return false if pos[1] >= 7
      end
    when :kyo
      if @player == :first
        return false if pos[1] <= 0
      else
        return false if pos[1] >= 8
      end
    when :fu
      if @player == :first
        return false if pos[1] <= 0
      else
        return false if pos[1] >= 8
      end
    end
    true
  end
end
