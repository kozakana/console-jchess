require 'drb/drb'
require 'pry'

DRb.start_service

#54000 port に接続
obj = DRbObject.new_with_uri('druby://localhost:54000')
#get = obj.test()
puts obj.to_s
