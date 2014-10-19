require 'drb/drb'
require 'pry'

class Piece
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

class Board
  def initialize
    @data = []
    @piece_stand = {}
    @piece_stand[:first]  = []
    @piece_stand[:second] = []


    @data << [
              Piece.new(:kyo, :second, false),  Piece.new,
              Piece.new(:fu, :second, false),  Piece.new, 
              Piece.new, Piece.new,
              Piece.new(:fu, :first, false),  Piece.new,
              Piece.new(:kyo, :first, false)
             ]

    @data << [
              Piece.new(:kei, :second, false), Piece.new(:kaku, :second, false),
              Piece.new(:fu, :second, false), Piece.new,
              Piece.new, Piece.new,
              Piece.new(:fu, :first, false), Piece.new(:hi, :first, false),
              Piece.new(:kei, :first, false)
             ]

    @data << [
              Piece.new(:gin, :second, false), Piece.new,
              Piece.new(:fu, :second, false), Piece.new,
              Piece.new, Piece.new,
              Piece.new(:fu, :first, false), Piece.new,
              Piece.new(:gin, :first, false)
             ]

    @data << [
              Piece.new(:kin, :second, false), Piece.new,
              Piece.new(:fu, :second, false), Piece.new,
              Piece.new, Piece.new,
              Piece.new(:fu, :first, false), Piece.new,
              Piece.new(:kin, :first, false)
             ]

    @data << [
              Piece.new(:gyoku, :second,false), Piece.new,
              Piece.new(:fu, :second, false), Piece.new,
              Piece.new, Piece.new,
              Piece.new(:fu, :first, false), Piece.new,
              Piece.new(:ou, :first, false)
             ]

    @data << [
              Piece.new(:kin, :second, false), Piece.new,
              Piece.new(:fu, :second, false), Piece.new,
              Piece.new, Piece.new,
              Piece.new(:fu, :first, false), Piece.new,
              Piece.new(:kin, :first, false)
             ]

    @data << [
              Piece.new(:gin, :second, false), Piece.new,
              Piece.new(:fu, :second, false), Piece.new,
              Piece.new, Piece.new,
              Piece.new(:fu, :first, false), Piece.new,
              Piece.new(:gin, :first, false)
             ]

    @data << [
              Piece.new(:kei, :second, false), Piece.new(:hi, :second, false),
              Piece.new(:fu, :second, false), Piece.new,
              Piece.new, Piece.new,
              Piece.new(:fu, :first, false), Piece.new(:kaku, :first, false),
              Piece.new(:kei, :first, false)
             ]

    @data << [
              Piece.new(:kyo, :second, false), Piece.new,
              Piece.new(:fu, :second, false), Piece.new,
              Piece.new,  Piece.new,
              Piece.new(:fu, :first, false), Piece.new,
              Piece.new(:kyo, :first, false)
             ]




#    @data << [
#              Piece.new(:kyo, :second, false),  Piece.new(:kei, :second, false),
#              Piece.new(:gin, :second, false),  Piece.new(:kin, :second, false), 
#              Piece.new(:gyoku, :second,false), Piece.new(:kin, :second, false),
#              Piece.new(:gin, :second, false),  Piece.new(:kei, :second, false),
#              Piece.new(:kyo, :second, false)
#             ]
#
#    @data << [
#              Piece.new, Piece.new(:kaku, :second, false),
#              Piece.new, Piece.new,
#              Piece.new, Piece.new,
#              Piece.new, Piece.new(:hi, :second, false),
#              Piece.new
#             ]
#
#    @data << [
#              Piece.new(:fu, :second, false), Piece.new(:fu, :second, false),
#              Piece.new(:fu, :second, false), Piece.new(:fu, :second, false),
#              Piece.new(:fu, :second, false), Piece.new(:fu, :second, false),
#              Piece.new(:fu, :second, false), Piece.new(:fu, :second, false),
#              Piece.new(:fu, :second, false)
#             ]
#
#    @data << [
#              Piece.new, Piece.new,
#              Piece.new, Piece.new,
#              Piece.new, Piece.new,
#              Piece.new, Piece.new,
#              Piece.new
#             ]
#
#    @data << [
#              Piece.new, Piece.new,
#              Piece.new, Piece.new,
#              Piece.new, Piece.new,
#              Piece.new, Piece.new,
#              Piece.new
#             ]
#
#    @data << [
#              Piece.new, Piece.new,
#              Piece.new, Piece.new,
#              Piece.new, Piece.new,
#              Piece.new, Piece.new,
#              Piece.new
#             ]
#
#    @data << [
#              Piece.new(:fu, :first, false), Piece.new(:fu, :first, false),
#              Piece.new(:fu, :first, false), Piece.new(:fu, :first, false),
#              Piece.new(:fu, :first, false), Piece.new(:fu, :first, false),
#              Piece.new(:fu, :first, false), Piece.new(:fu, :first, false),
#              Piece.new(:fu, :first, false)
#             ]
#
#    @data << [
#              Piece.new, Piece.new(:hi, :first, false),
#              Piece.new, Piece.new,
#              Piece.new, Piece.new,
#              Piece.new, Piece.new(:kaku, :first, false),
#              Piece.new
#             ]
#
#    @data << [
#              Piece.new(:kyo, :first, false), Piece.new(:kei, :first, false),
#              Piece.new(:gin, :first, false), Piece.new(:kin, :first, false),
#              Piece.new(:ou, :first, false),  Piece.new(:kin, :first, false),
#              Piece.new(:gin, :first, false), Piece.new(:kei, :first, false),
#              Piece.new(:kyo, :first, false)
#             ]
  end

  def to_s
    str  = "後手持駒：#{@piece_stand[:second]}\n"
    str += " 9   8   7   6   5   4   3   2   1 \n"
    line_title = ["一", "二", "三", "四", "五", "六", "七", "八", "九"]

    9.times do |y|
      9.times do |x|
        str += @data[8-x][y].to_s
        str += "|"
      end
      str += "#{line_title[y]}\n"
    end

    str += "先手持駒：#{@piece_stand[:first]}\n"
    str
  end

  def move before, after
    #exist? before[0], before[1]
    tmp = @data[before[0]][before[1]]
    @data[before[0]][before[1]] = Piece.new
    @data[after[0]][after[1]] = tmp
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
