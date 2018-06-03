defmodule PokerHands.Test.Rankers.FlushRankerTest do
  alias PokerHands.Rankers.FlushRanker, as: FlushRanker
  use ExUnit.Case

  test "ranks correcty as flush" do
    hand = [{:"2", :S}, {:"3", :S}, {:"4", :S}, {:"5", :S}, {:"6", :S}]

    assert FlushRanker.rank(hand) ==
             {true, [{:"2", :S}, {:"3", :S}, {:"4", :S}, {:"5", :S}, {:"6", :S}]}
  end
end
