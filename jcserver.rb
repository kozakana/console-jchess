require 'drb/drb'
require 'optparse'
require 'pry'
require './board'

def cmdline
  args = {ipaddr: "localhost", port: "1117"}
  OptionParser.new do |parser|
    parser.on('-i [VALUE]', '--ipaddr [VALUE]', '引数付きオプション(デフォルトlocalhost)') do |val|
      args[:ipaddr]=val if val!=nil
    end
    parser.parse!(ARGV)
  end 
  args
end

args = cmdline

server = "druby://:#{args[:port]}"

DRb.start_service(server, Board.instance)

while true
  sleep 1
end
