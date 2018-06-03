defmodule PokerHands.Test.Rankers.StraightRankerTest do
  alias PokerHands.Rankers.StraightRanker, as: StraightRanker
  use ExUnit.Case

  test "ranks correcty as straight" do
    hand = [{:"3", :S}, {:"2", :S}, {:"5", :S}, {:"6", :C}, {:"4", :C}]

    assert StraightRanker.rank(hand) ==
             {true, [{:"3", :S}, {:"2", :S}, {:"5", :S}, {:"6", :C}, {:"4", :C}]}
  end
end
