#Dir[File.expand_path('./pieces', __FILE__) << '/*.rb'].each do |file|
#    require file
#end

require './pieces/ou'
require './pieces/kin'
require './pieces/gin'
require './pieces/kei'
require './pieces/kyo'
require './pieces/fu'
require './pieces/hi'
require './pieces/kaku'
require './pieces/nil_piece'
require 'singleton'
require './board_data'

class ExistPiece < StandardError; end
class MissingPiece < StandardError; end
class CannotMove < StandardError; end

# TODO: 飛び駒の判定
# TODO: 二歩判定
# TODO: ログ機能
# TODO: 待った機能
# TODO: 負けました機能
# TODO: 自分の駒のあるところへは動けないように

class Board
  include Singleton
  attr_reader :order_first
  
  def initialize
    @data = BoardData.instance
    # @player[:first][:name]    = ""    # TODO
    # @player[:second][:name]   = ""    # TODO
    @order_list = {}
    @order_list[:audience] = Array.new
    @order_first = true
  end


  # TODO: id
  def connecting id
    if @order_list.value? id
      if @order_list[:first] == id
        puts "reconnect first:#{id}"
        return {order: :first, id: id}
      elsif @order_list[:second] == id
        puts "reconnect second:#{id}"
        return {order: :second, id: id}
      else
        puts "reconnect audience:#{id}"
        return {order: :audience, id: id}
      end
    end

    id = rand(1000000).to_s  # かぶる可能性

    if @order_list[:first] == nil
      puts "connect first:#{id}"
      @order_list[:first] = id
      {order: :first, id: id}
    elsif @order_list[:second] == nil
      puts "connect second:#{id}"
      @order_list[:second] = id
      {order: :second, id: id}
    else
      @order_list[:audience] << id
      puts "connect audience:#{id}"
      {order: :audience, id: id}
    end
  end

  def to_s
    @data.to_s
  end

  def move before, after, id
    unless exist? before
      raise MissingPiece, "動かそうとする駒がありません"
    end

    orig_piece = @data[before[0], before[1]]
    od = order id
    if orig_piece.player != od
      if od == :audience
        p "観戦者は駒を動かす事は出来ません"
        return
      else
        p "自分の駒以外は動かせません"
        return
      end
    end
    
    unless orig_piece.move? before, after
      raise CannotMove, "指定場所へは動かせません"
    end

    if piece(after).player == order(id)
      raise ExistPiece, "自分の駒は取れません"
    end

    rlist = road_list piece(before), before, after
    rlist.each do |pos|
      if piece(pos).kind != :nil
        p "他の駒は飛び越えられません"
        raise CannotMove, "他の駒は飛び越えられません"
      end
    end

    if exist? after
      p captured = @data[after[0], after[1]]
      if captured.player == :first
        captured.player = :second
        captured.grow = false
        @data.to_stand :second, captured
      else
        captured.player = :first
        captured.grow = false
        to_stand :first, captured
      end
    end
    @data[after[0],  after[1]]  = @data[before[0], before[1]]
    @data[before[0], before[1]] = NilPiece.new

    if can_grow? after
      if can_next? after
        status = {grow: :can}
      else
        status = {grow: :must}
      end
    else
      status = {grow: :cannot}
    end
    change_order
    status
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

  def change_order
    @order_first = @order_first ? false : true
  end

  def set pos, kind, id
    if exist? pos
      raise ExistPiece, "駒を打とうとしている場所に駒が存在しています"
    end
    
    unless player? id
      p "観戦者は駒を動かす事はできません"
      return
    end

    piece = piece_incetance(kind, order(id), false)
    
    if @data.on_stand? order(id), piece
      @data.del_piece order, piece
    else
      raise MissingPiece, "駒台に指定の駒がありません"
    end
    change_order
    @data[pos[0], pos[1]] = piece
  end

  def piece_incetance kind, order, grow
    case kind
    when :ou
      Ou.new(order, grow)
    when :kin
      Kin.new(order, grow)
    when :gin
      Gin.new(order, grow)
    when :kei
      Kei.new(order, grow)
    when :kyo
      Kyo.new(order, grow)
    when :fu
      Fu.new(order, grow)
    when :hi
      Hi.new(order, grow)
    when :kaku
      Kaku.new(order, grow)
    end
  end

  def exist? pos
    nil != @data[pos[0], pos[1]].player
  end

  def piece pos
    @data[pos[0], pos[1]]
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

  def can_next? pos
    pce = piece(pos)
    return true if pce.grow == true
    case pce.kind
    when :kei
      if pce.player == :first
        false if pos[1] <= 1
      else
        false if pos[1] >= 7
      end
      true
    when :kyo, :fu
      if pce.player == :first
        false if pos[1] <= 0
      else
        false if pos[1] >= 8
      end
      true
    else
      true
    end
  end
  
  def grow_piece pos
    piece(pos).grow = true
  end

  def road_list piece, before, after
    mlist = move_list piece, before
    rlist = []
    orig_dist = Math.sqrt((before[0]-after[0])**2 + (before[1]-after[1])**2)
    mlist.each do |pos|
      dist = Math.sqrt((pos[0]-after[0])**2 + (pos[1]-after[1])**2)

      if orig_dist > dist && dist != 0
        rlist << pos
      end
    end

    rlist
  end

  def move_list piece, pos
    list = []
    9.times do |x|
      9.times do |y|
        if piece.move? pos, [x, y]
          #dist = Math.sqrt((pos[0]-x)**2 + (pos[1]-y)**2)
          list << [x, y]
        end
      end
    end
    list
  end
end
