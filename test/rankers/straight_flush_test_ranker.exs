defmodule PokerHands.Test.Rankers.StraightFlushRankerTest do
  # alias PokerHands.Rankers.StraightFlush, as: StraightFlush
  use ExUnit.Case

  test "ranks correcty as straight flush" do
    hand = [{:"3", :S}, {:"2", :S}, {:"5", :S}, {:"6", :S}, {:"4", :S}]

    assert StraightRanker.rank(hand) ==
             {true, [{:"3", :S}, {:"2", :S}, {:"5", :S}, {:"6", :S}, {:"4", :S}]}
  end
end
