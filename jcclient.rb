require 'drb/drb'
require 'optparse'
require 'pry'

class CmmandFail < StandardError; end

class Client
  def initialize ipaddr, port
    DRb.start_service
    @obj = DRbObject.new_with_uri("druby://#{ipaddr}:#{port}")
  end

  def print
    puts @obj.to_s
  end

  def command str
    com = str.split(" ")

    case com[0]
    when "move" then
      #  raise CommandFail, "コマンドが間違っています\nmove_full 33 34"
      before = []; after = []

      before[0] = com[1][0].to_i - 1
      before[1] = com[1][1].to_i - 1

      after[0]  = com[2][0].to_i - 1
      after[1]  = com[2][1].to_i - 1
      status = @obj.move before, after
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
      # TODO
      @obj.set pos, kind, :first
    when "print" then
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
