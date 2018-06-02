defmodule PokerHands.Test.Rankers.SinglePairRankerTest do
  alias PokerHands.Rankers.SinglePairRanker, as: SinglePairRanker
  use ExUnit.Case

  test "ranks correcty as single pair" do
    hand = [{:"2", :H}, {:"3", :D}, {:"2", :S}, {:"9", :C}, {:K, :D}]
    assert SinglePairRanker.rank(hand) == {true, [{:"2", :H}, {:"2", :S}]}
  end
end