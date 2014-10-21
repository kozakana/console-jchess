require 'drb/drb'
require 'pry'

class CmmandFail < StandardError; end

class Client
  def initialize ipaddr
    DRb.start_service
    @obj = DRbObject.new_with_uri("druby://#{ipaddr}:54000")
  end

  def print
    puts @obj.to_s
  end

  def command str
    com = str.split(" ")

    case com[0]
    when "move_full" then
      #  raise CommandFail, "コマンドが間違っています\nmove_full 33 34"
      before = []; after = []

      before[0] = com[1][0].to_i - 1
      before[1] = com[1][1].to_i - 1

      after[0]  = com[2][0].to_i - 1
      after[1]  = com[2][1].to_i - 1
      @obj.move before, after
    when "print" then
    end
    puts @obj.to_s
  end
end

cl = Client.new ARGV[0]
while true
  str = STDIN.gets.chomp
  cl.command str
end
