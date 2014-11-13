require_relative '../board'

ID = 1

def init
  @kyo_pos  = [1, 7]
  @kaku_pos = [4, 4]
  @hi_pos   = [4, 7]

  data = Array.new(9).map{ Array.new(9, NilPiece.new) }
  data[@kyo_pos[0]][@kyo_pos[1]] =  Kyo.new(:first, false)
  data[@kaku_pos[0]][@kaku_pos[1]] =  Kaku.new(:first, false)
  data[@hi_pos[0]][@hi_pos[1]] =  Hi.new(:first, false)
  board_data = BoardData.instance
  board_data.instance_eval do 
    @data = data
  end
  @board = Board.instance
  @board.instance_eval do
    @data = board_data
    @order_list[:first] = ID
  end
end

describe Board do
  #it "road_listの確認" do
  #  pce = @board.piece [4,4]
  #  #p @board.road_list pce, [4,7], [0,7]
  #  p @board.move [4,7], [0,7], 1
  #end

  describe "飛び駒の飛び越し判定" do
    describe "香車" do
      before do
        @kyo_result = Array.new(9).map{ Array.new(9, CannotMove) }
        @kyo_result[1][0] = :success
        @kyo_result[1][1] = :success
        @kyo_result[1][2] = :success
        @kyo_result[1][3] = :success
        @kyo_result[1][4] = :success
        @kyo_result[1][5] = :success
        @kyo_result[1][6] = :success
        @kyo_result[1][7] = ExistPiece
      end
  
      it "moveのテスト" do
        9.times do |x|
          9.times do |y|
            init
            if @kyo_result[x][y] == :success
              @board.move [@kyo_pos[0], @kyo_pos[1]], [x,y], ID
            else
              expect do
                @board.move [@kyo_pos[0], @kyo_pos[1]], [x,y], ID
              end.to raise_error( @kyo_result[x][y] )
            end
          end
        end
      end
    end
    
    describe "飛車" do
      before do
        @hi_result = Array.new(9).map{ Array.new(9, CannotMove) }
        @hi_result[4][4] = ExistPiece
        @hi_result[4][5] = :success
        @hi_result[4][6] = :success
        @hi_result[4][7] = ExistPiece
        @hi_result[4][8] = :success
  
        @hi_result[0][7] = CannotMove
        @hi_result[1][7] = ExistPiece
        @hi_result[2][7] = :success
        @hi_result[3][7] = :success
        @hi_result[5][7] = :success
        @hi_result[6][7] = :success
        @hi_result[7][7] = :success
        @hi_result[8][7] = :success
      end
  
      it "moveのテスト" do
        9.times do |x|
          9.times do |y|
            init
            if @hi_result[x][y] == :success
              @board.move [@hi_pos[0], @hi_pos[1]], [x,y], ID
            else
              expect do
                @board.move [@hi_pos[0], @hi_pos[1]], [x,y], ID
              end.to raise_error( @hi_result[x][y] )
            end
          end
        end
      end
    end
  
    describe "角行" do
  
  
    end
  end
end
