defmodule PokerHands.Rankers.TwoPairRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  @behaviour HandRanker

  def rank(hand) do
    sets = CardHelper.get_sets(hand, 2)

    if Enum.count(sets) == 2 do
      sets_indices = get_sets_indices(sets)
      hand_indexed = Enum.with_index(hand)
      result = CardHelper.get_hand_result(hand_indexed, sets_indices)
      result
    else
      {false, []}
    end
  end

  def tie(hand_black, hand_white) do
    {:tie, hand_black, hand_white}
  end

  defp get_sets_indices(sets) do
    sets_flat = Enum.flat_map(sets, fn x -> x end)
    sets_indices = Enum.map(sets_flat, fn x -> elem(x, 1) end)
    sets_indices
  end
end
