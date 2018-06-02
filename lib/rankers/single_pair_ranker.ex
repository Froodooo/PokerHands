defmodule PokerHands.Rankers.SinglePairRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  @behaviour HandRanker

  def rank(hand) do
    pairs = CardHelper.get_pairs(hand)
    if Enum.count(pairs) == 0 do
      {false, []}
    else
      pairs_indices = get_pairs_indices(pairs)
      hand_indexed = Enum.with_index(hand)
      result = CardHelper.get_hand_result(hand_indexed, pairs_indices)
      result
    end
  end

  defp get_pairs_indices(pairs) do
    highest_pair_value = Enum.max(Enum.map(pairs, fn(x) -> elem(hd(x), 0) end))
    pairs_list = Enum.filter(pairs, fn(x) -> elem(hd(x), 0) == highest_pair_value end)
    pairs_flat = Enum.flat_map(pairs_list, fn(x) -> x end)
    pairs_indices = Enum.map(pairs_flat, fn(x) -> elem(x, 1) end)
    pairs_indices
  end
end