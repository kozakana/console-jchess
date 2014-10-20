require 'drb/drb'
require 'pry'
require './board'

#54000 port で受ける
DRb.start_service('druby://localhost:54000',Board.new)

while true
  sleep 1
end
