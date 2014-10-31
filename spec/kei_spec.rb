require_relative '../pieces/kei'

describe Kei do
  describe "先手" do
    before do
      @pce = Kei.new
      @pce.grow   = false
      @pce.player = :first
      
      @init_pos = [4, 4]
      # 行く事が可能な所はtrue
      @first_move = Array.new(9).map{ Array.new(9, false) }
      @first_move[3][2] = true
      @first_move[4][4] = true
      @first_move[5][2] = true

    end

    it "moveの確認" do
      9.times do |x|
        9.times do |y|
          expect(@pce.move?(@init_pos, [x, y])).to eq @first_move[x][y]
        end
      end
    end
  end
  
  describe "後手" do
    before do
      @pce = Kei.new
      @pce.grow   = false
      @pce.player = :second
    
      @init_pos = [4, 4]
      # 行く事が可能な所はtrue
      @second_move = Array.new(9).map{ Array.new(9, false) }
      @second_move[3][6] = true
      @second_move[4][4] = true
      @second_move[5][6] = true
    end

    it "moveの確認" do
      9.times do |x|
        9.times do |y|
          expect(@pce.move?(@init_pos, [x, y])).to eq @second_move[x][y]
        end
      end
    end
  end
end
