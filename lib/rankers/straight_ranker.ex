defmodule PokerHands.Rankers.StraightRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  @behaviour HandRanker
  
  def rank(hand) do
    hand_order_indexed = CardHelper.get_hand_order_indexed(hand)
    hand_values = Enum.map(hand_order_indexed, fn(x) -> elem(x, 0) end)
    hand_values_ordered = Enum.sort(hand_values)
    
    if (is_increasing_list(hand_values_ordered, hd(hand_values_ordered))), do: {true, hand}, else: {false, []}
  end

  def is_increasing_list(list, v) when tl(list) == [] do
    if hd(list) != v, do: false, else: true
  end

  def is_increasing_list(list, v) do
    is_increasing_list(tl(list), v + 1)
  end

end