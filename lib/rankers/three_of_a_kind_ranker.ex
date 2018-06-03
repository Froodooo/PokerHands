defmodule PokerHands.Rankers.ThreeOfAKindRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  @behaviour HandRanker

  def rank(hand) do
    sets = CardHelper.get_sets(hand, 3)

    if Enum.count(sets) == 0 do
      {false, []}
    else
      sets_indices = CardHelper.get_sets_indices(sets)
      hand_indexed = Enum.with_index(hand)
      result = CardHelper.get_hand_result(hand_indexed, sets_indices)
      result
    end
  end

  def tie(hand_black, hand_white) do
    pair_black = elem(hand_black, 1)
    pair_white = elem(hand_white, 1)

    pair_black_order = CardHelper.get_hand_order_indexed(pair_black)
    pair_white_order = CardHelper.get_hand_order_indexed(pair_white)

    value_black = elem(Enum.at(pair_black_order, 0), 0)
    value_white = elem(Enum.at(pair_white_order, 0), 0)

    cond do
      value_black > value_white -> :black
      value_white > value_black -> :white
      true -> :tie
    end
  end
end
