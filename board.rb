require './piece'
require 'singleton'

class ExistPiece < StandardError; end
class MissingPiece < StandardError; end

# TODO: 飛び駒の判定
# TODO: 二歩判定

class Board
  include Singleton
  
  def initialize
    init_board
  end

  def init_board
    # @player[:first][:name]    = ""    # TODO
    # @player[:second][:name]   = ""    # TODO
    @order_list = {}
    @order_list[:audience] = Array.new
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
              Piece.new(:ou, :second,false), Piece.new,
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

  def connecting id
    if @order_list.value? id
      return
    end

    if @order_list.length == 0
      @order_list[:first] = id
    elsif @order_list.length == 1
      @order_list[:second] = id
    else
      @order_list[:audience] << id
    end
  end

  def to_s
    str  = "後手持駒："
    @piece_stand[:second].each do |pce|
      str += pce.to_s
    end
    str += "\n"
    str += " 9   8   7   6   5   4   3   2   1 \n"
    line_title = ["一", "二", "三", "四", "五", "六", "七", "八", "九"]

    9.times do |y|
      9.times do |x|
        str += @data[8-x][y].to_s
        str += "|"
      end
      str += "#{line_title[y]}\n"
    end

    str += "先手持駒："
    @piece_stand[:first].each do |pce|
      str += pce.to_s
    end
    str += "\n"
    str
  end

  def move before, after
    unless exist? before
      raise MissingPiece, "動かそうとする駒がありません"
    end

    if exist? after
      captured = @data[after[0]][after[1]]
      if captured.player == :first
        captured.player = :second
        @piece_stand[:second] << captured
      else
        captured.player = :first
        @piece_stand[:first] << captured
      end
    end

    @data[after[0]][after[1]]   = @data[before[0]][before[1]]
    @data[before[0]][before[1]] = Piece.new

    if can_grow? after
      if piece(after).can_next?(after)
        return {grow: :can}
      else
        return {grow: :must}
      end
    else
      return {grow: :cannot}
    end
  end
  
  def player? id
    if @order_list[:first] == id || @order_list[:second] == id
      return true
    end
    false
  end

  def order id
    if @order_list[:first] == id
      return :first
    elsif @order_list[:second] == id
      return :second
    else
      return :audience
    end
  end

  def set pos, kind, id
    if exist? pos
      raise ExistPiece, "駒を打とうとしている場所に駒が存在しています"
    end
    
    unless player?
      p "プレーヤーではありません"
    end
    
    piece = Piece.new(kind, order(id), false)
    
    if @piece_stand[order(id)].include?(piece)
      @piece_stand[order(id)].each_with_index do |p, i|
        if p == piece
          @piece_stand[order(id)].delete_at i
          break
        end
      end
    else
      raise MissingPiece, "駒台に指定の駒がありません"
    end

    @data[pos[0]][pos[1]] = piece
  end

  def exist? pos
    nil != @data[pos[0]][pos[1]].player
  end

  def piece pos
    @data[pos[0]][pos[1]]
  end

  def first? pos
    piece(pos).player == :first
  end

  def can_grow? pos
    pce = piece pos
    if pce.player == :first
      true if pos[1] <= 2
    else
      true if pos[1] >= 6
    end
  end
  
  def grow_piece pos
    piece(pos).grow = true
  end
end
