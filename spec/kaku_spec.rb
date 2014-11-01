require_relative '../pieces/kaku'

describe Hi do
  describe "不成り" do
    before do
      @pce = Hi.new
      @pce.grow   = false
      @pce.player = :first
      
      @init_pos = [4, 4]
      # 行く事が可能な所はtrue
      @move = Array.new(9).map{ Array.new(9, false) }
      @move[0][0] = true
      @move[0][8] = true
      @move[1][1] = true
      @move[1][7] = true
      @move[2][2] = true
      @move[2][6] = true
      @move[3][3] = true
      @move[3][5] = true
      @move[4][4] = true
      @move[5][5] = true
      @move[5][3] = true
      @move[6][6] = true
      @move[6][2] = true
      @move[7][7] = true
      @move[7][1] = true
      @move[8][8] = true
      @move[8][0] = true
    end

    it "moveの確認" do
      9.times do |x|
        9.times do |y|
          expect(@pce.move?(@init_pos, [x, y])).to eq @move[x][y]
        end
      end
    end
  end

  describe "成り" do
    before do
      @pce = Hi.new
      @pce.grow   = true
      @pce.player = :first
      
      @init_pos = [4, 4]
      # 行く事が可能な所はtrue
      @move = Array.new(9).map{ Array.new(9, false) }
      @move[0][0] = true
      @move[0][8] = true
      @move[1][1] = true
      @move[1][7] = true
      @move[2][2] = true
      @move[2][6] = true
      @move[3][3] = true
      @move[3][4] = true
      @move[3][5] = true
      @move[4][3] = true
      @move[4][4] = true
      @move[4][5] = true
      @move[5][5] = true
      @move[5][4] = true
      @move[5][3] = true
      @move[6][6] = true
      @move[6][2] = true
      @move[7][7] = true
      @move[7][1] = true
      @move[8][8] = true
      @move[8][0] = true
    end

    it "moveの確認" do
      9.times do |x|
        9.times do |y|
          expect(@pce.move?(@init_pos, [x, y])).to eq @move[x][y]
        end
      end
    end
  end
end
