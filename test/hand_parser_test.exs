defmodule HandParserTest do
  alias PokerHands.HandParser, as: HandParser
  use ExUnit.Case

  test "parses hand correctly" do
    assert HandParser.parse("2H 3D 5S 9C KD") == [
             {:"2", :H},
             {:"3", :D},
             {:"5", :S},
             {:"9", :C},
             {:K, :D}
           ]
  end
end
