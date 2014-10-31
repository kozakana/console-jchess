require_relative '../pieces/ou'
require 'pry'
require 'pp'

describe Ou do
  before do
    @ou = Ou.new
    @ou.player = :first
    @ou.grow   = false
    
    @init_pos = [4, 4]
    # 行く事が可能な所はtrue
    @move = Array.new(9).map{ Array.new(9, false) }
    @move[3][3] = true
    @move[3][4] = true
    @move[3][5] = true
    @move[4][3] = true
    @move[4][4] = true
    @move[4][5] = true
    @move[5][3] = true
    @move[5][4] = true
    @move[5][5] = true
  end

  it "moveの確認" do
    9.times do |x|
      9.times do |y|
        expect(@ou.move?(@init_pos, [x, y])).to eq @move[x][y]
      end
    end
  end
end
