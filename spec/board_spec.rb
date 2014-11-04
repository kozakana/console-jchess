require_relative '../board'


describe Board do
  describe "road_list" do
    before do
      data = Array.new(9).map{ Array.new(9, NilPiece.new) }
      data[1][7] =  Kyo.new(:first, false)
      data[4][4] =  Kaku.new(:first, false)
      data[4][7] =  Hi.new(:first, false)
      @board = Board.instance
      @board.instance_eval do 
        @data = data

        @order_list[:first] = 1
      end
    end

    it "road_listの確認" do
      pce = @board.piece [4,4]
      #p @board.road_list pce, [4,7], [0,7]
      p @board.move [4,7], [0,7], 1
    end
  end
end
