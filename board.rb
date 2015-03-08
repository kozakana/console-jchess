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
class Nifu < StandardError; end

# TODO: ログ機能
# TODO: 待った機能

class Board
  include Singleton
  attr_reader :order_first, :number_of_moves
  attr_accessor :status
  
  def initialize
    @data = BoardData.new
    # @player[:first][:name]    = ""    # TODO
    # @player[:second][:name]   = ""    # TODO
    @order_list = {}
    @order_list[:audience] = Array.new
    @order_first = true
    @status = :playing
    @number_of_moves = 0
  end

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

  def disp order
    if order == :audience
      @data.disp :first
    else
      @data.disp order
    end
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
        @data.to_stand :first, captured
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
    @number_of_moves += 1
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

    if exist_column_fu?(pos[0], order(id))
      raise Nifu, "二歩です"
    end

    piece = piece_incetance(kind, order(id), false)
    
    if @data.on_stand? order(id), piece
      @data.del_piece order(id), piece
    else
      raise MissingPiece, "駒台に指定の駒がありません"
    end
    change_order
    @data[pos[0], pos[1]] = piece
  end

  def exist_column_fu? column, order
    9.times do |row|
      pce = @data[column, row]
      if pce.player == order && pce.grow == false && pce.class == Fu
        return true
      end
    end

    return false
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
    orig_dist = Math.sqrt((before[0]-after[0])**2 + (before[1]-after[1])**2).round(2)
    mlist.each do |pos|
      dist_a_p = Math.sqrt((pos[0]-after[0])**2 + (pos[1]-after[1])**2)
      dist_b_p = Math.sqrt((pos[0]-before[0])**2 + (pos[1]-before[1])**2)
      sum_dist = (dist_a_p + dist_b_p).round(2)
      dist_a_p = dist_a_p.round(2)
      dist_b_p = dist_b_p.round(2)

      if orig_dist > dist_a_p && dist_a_p != 0 && sum_dist == orig_dist
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

  def check_mate? id
    now_order = order id
    oute? now_order
    # 自分の王の場所を探す
    position = ou_enemy_pos now_order
    # 王手がかかっているか？
    oute_list = get_oute_list(position[:ou], position[:enemy])
    return false if oute_list == nil

    # 王手をかけている駒を王以外で取れるか
    if oute_list.length == 1
      if remove_oute(oute_list, position[:friend])
        return false
      end
    end

    # 合駒可能か？
    if can_guard? oute_list
      return false
    end

    # 王の移動出来る場所を探す
    # 動かしてみてもう一度上の処理で撮れる状態か

  end

  def can_guard? now_order, pos_ou, oute_list
    if @data.piece_stand[now_order].length < 1
      return false
    end
    
    oute_list.each do |enemy|
      pce = piece(enemy)
      if pce.kind == :fu || 
         pce.kind == :kyo || 
         pce.kind == :hi  || 
         pce.kind == :kaku

        rlist = road_list(pce, enemy, pos_ou)
        rlist.each do |fly_pos|
          if piece(fly_pos).kind == nil
            # TODO: 駒を置く事が可能か
            if exist_column_fu?(pos[0], order(id))
            end
          end
        end
      end
    end
    false
  end

  def set_piece? pce, pos, now_order
    case pce.kind
    when :fu
      if exist_column_fu?(pos[0], now_order)
        false
      else
        true
      end
    when :kyo, :kaku, :hi
      rlist = road_list(pce, enemy, pos_ou)
      rlist.each do |fly_pos|
        if piece(fly_pos).kind == nil
        end
      end
    else
      true
    end
  end

  def remove_oute oute_list, friend_list
    oute_list.each do |enemy|
      position[:friend].each do |friend|
        if piece(friend).move?(friend, enemy)
          return true
        end
      end
    end
    false
  end

  def get_pos now_order
    ou = nil
    enemy = []
    friend = []
    9.times do |x|
      9.times do |y|
        pce = @data[x,y]
        if pce.player == now_order
          if pce.kind == :ou
            ou = [x, y]
          else
            friend << [x, y]
          end
        end

        if pce.player != now_order
          enemy << [x, y]
        end
      end
    end

    {ou: ou, friend: friend, enemy: enemy}
  end

  def get_oute_list ou_pos, enemy_list
    oute_list = nil
    enemy_list.each do |enemy|
      if piece(enemy).move?(enemy, ou_pos)
        oute_list << enemy
      end
    end
    oute_list
  end
end
