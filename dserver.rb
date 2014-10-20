require 'drb/drb'
require 'pry'

class ExistPiece < StandardError; end
class MissingPiece < StandardError; end

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

class Board
  def initialize
    @data = []
    @piece_stand = {}
    @piece_stand[:first]  = []
    @piece_stand[:second] = []


    @data << [
              Piece.new(:kyo, :second, false), Piece.new,
              Piece.new(:fu, :second, false),  Piece.new, 
              Piece.new,                       Piece.new,
              Piece.new(:fu, :first, false),   Piece.new,
              Piece.new(:kyo, :first, false)
             ]

    @data << [
              Piece.new(:kei, :second, false), Piece.new(:kaku, :second, false),
              Piece.new(:fu, :second, false),  Piece.new,
              Piece.new,                       Piece.new,
              Piece.new(:fu, :first, false),   Piece.new(:hi, :first, false),
              Piece.new(:kei, :first, false)
             ]

    @data << [
              Piece.new(:gin, :second, false), Piece.new,
              Piece.new(:fu, :second, false),  Piece.new,
              Piece.new,                       Piece.new,
              Piece.new(:fu, :first, false),   Piece.new,
              Piece.new(:gin, :first, false)
             ]

    @data << [
              Piece.new(:kin, :second, false), Piece.new,
              Piece.new(:fu, :second, false),  Piece.new,
              Piece.new,                       Piece.new,
              Piece.new(:fu, :first, false),   Piece.new,
              Piece.new(:kin, :first, false)
             ]

    @data << [
              Piece.new(:gyoku, :second,false), Piece.new,
              Piece.new(:fu, :second, false),   Piece.new,
              Piece.new,                        Piece.new,
              Piece.new(:fu, :first, false),    Piece.new,
              Piece.new(:ou, :first, false)
             ]

    @data << [
              Piece.new(:kin, :second, false), Piece.new,
              Piece.new(:fu, :second, false),  Piece.new,
              Piece.new,                       Piece.new,
              Piece.new(:fu, :first, false),   Piece.new,
              Piece.new(:kin, :first, false)
             ]

    @data << [
              Piece.new(:gin, :second, false), Piece.new,
              Piece.new(:fu, :second, false),  Piece.new,
              Piece.new,                       Piece.new,
              Piece.new(:fu, :first, false),   Piece.new,
              Piece.new(:gin, :first, false)
             ]

    @data << [
              Piece.new(:kei, :second, false), Piece.new(:hi, :second, false),
              Piece.new(:fu, :second, false),  Piece.new,
              Piece.new,                       Piece.new,
              Piece.new(:fu, :first, false),   Piece.new(:kaku, :first, false),
              Piece.new(:kei, :first, false)
             ]

    @data << [
              Piece.new(:kyo, :second, false), Piece.new,
              Piece.new(:fu, :second, false),  Piece.new,
              Piece.new,                       Piece.new,
              Piece.new(:fu, :first, false),   Piece.new,
              Piece.new(:kyo, :first, false)
             ]
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
    unless exist? before
      raise MissingPiece, "動かそうとする駒がありません"
    end

    if exist? after
      captured = @data[after[0]][after[1]]
      if captured.player == :first
        @piece_stand[:first] = captured
      else
        @piece_stand[:second] = captured
      end
    else
      raise ExistPiece, "異動先に既に駒が存在しています"
    end
    @data[after[0]][after[1]]   = @data[before[0]][before[1]]
    @data[before[0]][before[1]] = Piece.new
  end

  def set pos, piece
    if exist? pos
      raise ExistPiece, "駒を打とうとしている場所に駒が存在しています"
    end
    
    player = piece.player
    if @piece_stand[player].exist?(piece)
      @piece_stand[player].each_with_index do |p, i|
        if p == piece
          @piece_stand.delete_at i
          break
        end
      end
      
    else
      raise MissingPiece, "駒台に指定の駒がありません"
    end
  end

  def exist? pos
    nil != @data[pos[0]][pos[1]].player
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
