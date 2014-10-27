class NilPiece < Piece
  def ==(pce)
    pce.class == 'NilPiece'
  end

  # TODO:例外にした方がいいかも
  def move? before, after
    false
  end

  def disp
    "  "
  end
end
