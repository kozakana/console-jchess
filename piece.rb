class Piece
  attr_reader :player

  def initialize kind=nil, player=nil, grow=nil
    @kind   = kind
    @player = player
    @grow   = grow
  end

  def disp_kind kind
    case kind
    when :gyoku
      "玉"
    when :ou
      "王"
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
