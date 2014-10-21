class Piece
  attr_reader :player

  def initialize kind=nil, player=nil, grow=nil
    @kind   = kind
    @player = player
    @grow   = grow
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

    when :kei
    when :kyo
    when :fu
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
end
