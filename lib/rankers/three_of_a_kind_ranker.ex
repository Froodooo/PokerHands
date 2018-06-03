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
    {:tie, hand_black, hand_white}
  end
end
