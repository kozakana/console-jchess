require_relative '../board'

def init
  data = Array.new(9).map{ Array.new(9, NilPiece.new) }
  data[1][7] =  Kyo.new(:first, false)
  data[4][4] =  Kaku.new(:first, false)
  data[4][7] =  Hi.new(:first, false)
  board_data = BoardData.instance
  board_data.instance_eval do 
    @data = data
  end
  @board = Board.instance
  @board.instance_eval do
    @data = board_data
    @order_list[:first] = 1
  end
end

describe Board do
  #it "road_listの確認" do
  #  pce = @board.piece [4,4]
  #  #p @board.road_list pce, [4,7], [0,7]
  #  p @board.move [4,7], [0,7], 1
  #end

  describe "香車" do
    before { init }
    it "moveのテスト" do
     # expect do
     #  p @board.move [1,7], [0,7], 1
     # end.to raise_error( MissingPiece )
       p @board.move [1,7], [1,6], 1
    end
  end
  
  describe "飛車" do


  end

  describe "角行" do


  end
end
