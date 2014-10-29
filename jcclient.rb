require 'drb/drb'
require 'optparse'
require 'readline'
require 'pry'

class CmmandFail < StandardError; end

IDFILE = "./.jcid"

class Client
  attr_reader :order

  def initialize param
    DRb.start_service
    @obj = DRbObject.new_with_uri("druby://#{param[:ipaddr]}:#{param[:port]}")
    
    # 再接続の場合
    if param[:id] != nil
      @id  = param[:id]
      info = @obj.connecting @id
      @order = info[:order]
      print_order info[:order]
      return
    end

    info = @obj.connecting nil
    @id = info[:id]
    @order = info[:order]
    print_order info[:order]
    File.open(IDFILE, "w") do |f|
      f.write @id
    end
  end

  def print
    puts @obj.to_s
  end

  def print_order order
    case order
    when :first
      puts "あなたは先手です"
    when :second
      puts "あなたは後手です"
    else
      puts "あなたは観戦者です"
    end
  end

  # 先後変化するときtrue
  def command str
    return if str == ""

    com = str.split(" ")

    case com[0]
    when "move", "mv" then
      #  raise CommandFail, "コマンドが間違っています\nmove_full 33 34"
      before = []; after = []

      before[0] = com[1][0].to_i - 1
      before[1] = com[1][1].to_i - 1

      after[0]  = com[2][0].to_i - 1
      after[1]  = com[2][1].to_i - 1
      begin
        status = @obj.move before, after, @id
      rescue => e
        if e.message == "MissingPiece"
          puts "動かそうとする駒がありません"
        elsif e.message == "ExistPiece"
          puts "移動先に自分の駒があります"
        else
          p e
        end
        return false
      end
      
      if status == nil
        return false
      end

      if status[:grow] == :can
        if grow_ask
          @obj.grow_piece after
        end
      elsif status[:grow] == :must
        @obj.piece(after).grow = true
      end
    when "set" then
      com = str.split(" ")
      pos = []
      pos[0] = com[1][0].to_i - 1
      pos[1] = com[1][1].to_i - 1
      unless piece_name? com[2]
        puts "駒の指定が間違っています"
        return false
      end
      kind = com[2].to_sym
      begin
        @obj.set pos, kind, @id
      rescue => e
        if e.message == "MissingPiece"
          puts "駒台に駒がありません"
        elsif e.message == "ExistPiece"
          puts "打つ場所に自分の駒があります"
        else
          p e
        end
        return false
      end
    #when "print" then
    when "help" then
      f = open("./doc/help.txt")
      puts f.read
      f.close
      return false
    else
      puts "コマンドが間違っています"
      return false
    end
    puts @obj.to_s
    return true
  end
  
  def my_order?
    case @order
    when :first
      @obj.order_first
    when :second
      !@obj.order_first
    else
      false
    end
  end
  
  def grow_ask
    while true
      puts "駒を成りますか？[y/n]"
      ans = gets.chomp
      if ans =~ /y|Y|yes|Yes|YES/
        return true
      elsif ans =~ /n|N|no|No|NO/
        return false
      end
    end
  end

  def piece_name? name
    name_list = ["ou", "kin", "gin", "kei", "kyo", "fu", "kaku", "hi"]
    name_list.include? name
  end
end

#if ARGV.length == 0
#  ipaddr = "localhost"
#else
#  ipaddr = ARGV[0]
#end

def cmdline
  args = {ipaddr: "localhost", port: "1117"}
  OptionParser.new do |parser|
    parser.on('-i [VALUE]', '--ipaddr [VALUE]', '引数付きオプション(デフォルトlocalhost)') do |val|
      args[:ipaddr]=val if val!=nil
    end
    parser.on('-p [VALUE]', '--port [VALUE]', 'ポート番号指定(デフォルト1117)') do |val|
      args[:port]=val if val!=nil
    end
    parser.on('-r', '--reconnect', '再接続を行いたい場合は指定') do |val|
      args[:id] = File.read(IDFILE)
    end
    parser.parse!(ARGV)
  end 
  args
end

args = cmdline
cl = Client.new args
unless cl.my_order?
  cl.print
end

consol = 
  case cl.order
  when :first
    "先手"
  when :second
    "後手"
  else
    "観戦者"
  end

consol += "> "

loop do
  unless cl.my_order?
    sleep 1
    next
  end
  cl.print
  line = Readline::readline(consol)
  break if line.nil? || line == 'quit'
  Readline::HISTORY.push(line)
  cl.command line
end
