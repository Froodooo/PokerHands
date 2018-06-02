defmodule HighardRankerTest do
  alias PokerHands.Rankers.HighCardRanker, as: HighCardRanker
  use ExUnit.Case

  test "ranks correcty as high card" do
    hand = [{:"2", :H}, {:"3", :D}, {:"5", :S}, {:"9", :C}, {:K, :D}]
    assert HighCardRanker.rank(hand) == true
  end

end