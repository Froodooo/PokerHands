defmodule PokerHands.Test.Rankers.FourOfAKindRankerTest do
  alias PokerHands.Rankers.FourOfAKindRanker, as: FourOfAKindRanker
  use ExUnit.Case

  test "ranks correcty as four of a kind" do
    hand = [{:"2", :H}, {:"3", :D}, {:"2", :S}, {:"2", :C}, {:"2", :D}]

    assert FourOfAKindRanker.rank(hand) ==
             {true, [{:"2", :H}, {:"2", :S}, {:"2", :C}, {:"2", :D}]}
  end
end
