defmodule PokerHands.Test.Rankers.FullHouseRankerTest do
  alias PokerHands.Rankers.FullHouseRanker, as: FullHouseRanker
  use ExUnit.Case

  test "ranks correcty as full house" do
    hand = [{:"2", :S},{:"3", :S},{:"4", :S},{:"5", :C},{:"6", :C}]
    assert FullHouseRanker.rank(hand) == {true, [{:"2", :S},{:"3", :S},{:"4", :S},{:"5", :C},{:"6", :C}]}
  end
end