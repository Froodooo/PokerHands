defmodule PokerHands.Test.Rankers.TwoPairRankerTest do
  alias PokerHands.Rankers.TwoPairRanker, as: TwoPairRanker
  use ExUnit.Case

  test "ranks correcty as two pair" do
    hand = [{:"2", :H}, {:"3", :D}, {:"2", :S}, {:"3", :C}, {:K, :D}]
    assert TwoPairRanker.rank(hand) == {true, [{:"2", :H}, {:"3", :D}, {:"2", :S}, {:"3", :C}]}
  end
end
