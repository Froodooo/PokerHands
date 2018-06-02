defmodule PokerHands.Test.Rankers.ThreeOfAKindRankerTest do
  alias PokerHands.Rankers.ThreeOfAKindRanker, as: ThreeOfAKindRanker
  use ExUnit.Case

  test "ranks correcty as three of a kind" do
    hand = [{:"2", :H}, {:"3", :D}, {:"2", :S}, {:"3", :C}, {:"2", :D}]
    assert ThreeOfAKindRanker.rank(hand) == {true, [{:"2", :H}, {:"2", :S}, {:"2", :D}, ]}
  end
end