defmodule PokerHands.Rankers.SinglePairRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  @behaviour HandRanker

  def rank(hand) do
    pairs = get_single_pairs(hand)
    if Enum.count(pairs) == 0 do
      {false, []}
    else
      highest_pair_value = Enum.max(Enum.map(pairs, fn(x) -> elem(hd(x), 0) end))
      pairs_result = Enum.filter(pairs, fn(x) -> elem(hd(x), 0) == highest_pair_value end)
      {true, pairs_result}
    end
  end

  defp get_single_pairs(hand) do
    hand_order_indexed = CardHelper.get_hand_order_indexed(hand)
    hand_order_grouped = Enum.group_by(hand_order_indexed, fn(x) -> elem(x, 0) end)
    hand_order_grouped_values = Map.values(hand_order_grouped)
    pairs = Enum.filter(hand_order_grouped_values, fn(x) -> Enum.count(x) == 2 end)
    pairs
  end
end