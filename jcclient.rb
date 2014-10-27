require 'drb/drb'
require 'optparse'
require 'pry'

class CmmandFail < StandardError; end

class Client
  def initialize ipaddr, port
    DRb.start_service
    @obj = DRbObject.new_with_uri("druby://#{ipaddr}:#{port}")
    @id = rand(1000000).to_s
    puts @obj.connecting @id
  end

  def print
    puts @obj.to_s
  end

  def command str
    return if str == ""

    com = str.split(" ")

    case com[0]
    when "move" then
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
        return
      end
      
      if status == nil
        return
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
        return
      end
    when "print" then
    when "help" then
      f = open("./doc/help.txt")
      puts f.read
      f.close
      return
    else
      puts "コマンドが間違っています"
      return
    end
    puts @obj.to_s
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
end

if ARGV.length == 0
  ipaddr = "localhost"
else
  ipaddr = ARGV[0]
end

def cmdline
  args = {ipaddr: "localhost", port: "1117"}
  OptionParser.new do |parser|
    parser.on('-i [VALUE]', '--ipaddr [VALUE]', '引数付きオプション(デフォルトlocalhost)') do |val|
      args[:ipaddr]=val if val!=nil
    end
    parser.on('-p [VALUE]', '--port [VALUE]', 'ポート番号指定(デフォルト1117)') do |val|
      args[:port]=val if val!=nil
    end
    parser.parse!(ARGV)
  end 
  args
end

args = cmdline
cl = Client.new args[:ipaddr], args[:port]

while true
  str = STDIN.gets.chomp
  cl.command str
end
