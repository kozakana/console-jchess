require 'drb/drb'

class Piece
  def initialize kind, player, grow
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
    when :kyou
      "香"
    when :fu
      "歩"
    when :hi
      "飛"
    when :kaku
      "角"
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
    str += "|"
    str
  end
end

class Board

  def initialize
    @data = []
    @piece_stand = {}
    @piece_stand[:first]  = []
    @piece_stand[:second] = []
    @data << [
              [" 香", :second], [" 桂", :second], [" 銀", :second],
              [" 金", :second], [" 玉", :second], [" 金", :second],
              [" 銀", :second], [" 桂", :second], [" 香", :second]
             ]

    @data << [
              [nil, nil], [" 角", :second], [nil, nil],
              [nil, nil], [nil, nil],       [nil, nil],
              [nil, nil], [" 飛", :second], [nil, nil]
             ]

    @data << [
              [" 歩", :second], [" 歩", :second], [" 歩", :second],
              [" 歩", :second], [" 歩", :second], [" 歩", :second],
              [" 歩", :second], [" 歩", :second], [" 歩", :second]
             ]

    @data << [
              [nil, nil], [nil, nil], [nil, nil],
              [nil, nil], [nil, nil], [nil, nil],
              [nil, nil], [nil, nil], [nil, nil]
             ]

    @data << [
              [nil, nil], [nil, nil], [nil, nil],
              [nil, nil], [nil, nil], [nil, nil],
              [nil, nil], [nil, nil], [nil, nil]
             ]

    @data << [
              [nil, nil], [nil, nil], [nil, nil],
              [nil, nil], [nil, nil], [nil, nil],
              [nil, nil], [nil, nil], [nil, nil]
             ]

    @data << [
              [" 歩", :first], [" 歩", :first], [" 歩", :first],
              [" 歩", :first], [" 歩", :first], [" 歩", :first],
              [" 歩", :first], [" 歩", :first], [" 歩", :first]
             ]

    @data << [
              [nil, nil], [" 飛", :first], [nil, nil],
              [nil, nil], [nil, nil],     [nil, nil],
              [nil, nil], [" 角", :first], [nil, nil]
             ]

    @data << [
              [" 香", :first], [" 桂", :first], [" 銀", :first],
              [" 金", :first], [" 王", :first], [" 金", :first],
              [" 銀", :first], [" 桂", :first], [" 香", :first]
             ]
  end

  def to_s
    str  = "後手持駒：#{@piece_stand[:second]}\n"
    str += " 9   8   7   6   5   4   3   2   1 \n"
    line_title = ["一", "二", "三", "四", "五", "六", "七", "八", "九"]
    @data.each_with_index do |line, idx|
      line.each do |piece|
        if piece[0] == nil
          str += "   |"
        else
          if piece[1] == :first
            str += "\e[32m"
          else
            str += "\e[31m"
          end
          str += "#{piece[0]}"
          str += "\e[0m"
          str += "|"
        end
      end
      str += "#{line_title[idx]}\n"
    end
    str += "先手持駒：#{@piece_stand[:first]}\n"
    str
  end

  def move before, after
    exist? before[0], before[1]
  end

  def set
  end

  def exist? row, line
    nil != @data[line][row][0]
  end

  def piece row, line
    @data[line][row]
  end
end

#54000 port で受ける
DRb.start_service('druby://localhost:54000',Board.new)

while true
  sleep 1
end
