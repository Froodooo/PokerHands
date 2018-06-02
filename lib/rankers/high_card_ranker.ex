defmodule PokerHands.Rankers.HighCardRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  @behaviour HandRanker

  def rank(hand) do
    hand_order_indexed = CardHelper.get_hand_order_indexed(hand)
    all_highest_orders_indices = get_highest_order_indices(hand_order_indexed)    
    hand_with_index = Enum.with_index(hand)
    result = get_hand_result(hand_with_index, all_highest_orders_indices)
    result
  end

  defp get_highest_order_indices(hand_order_indexed) do
    highest_order = Enum.max_by(hand_order_indexed, fn(x) -> elem(x, 0) end)
    all_highest_orders = Enum.filter(hand_order_indexed, fn(x) -> elem(x, 0) == elem(highest_order, 0) end)
    all_highest_orders_indices = Enum.map(all_highest_orders, fn(x) -> elem(x, 1) end)
    all_highest_orders_indices
  end

  defp get_hand_result(hand_with_index, all_highest_orders_indices) do
    hand_result_with_index = Enum.filter(hand_with_index, fn(x) -> elem(x, 1) in all_highest_orders_indices end)
    hand_result = Enum.map(hand_result_with_index, fn(x) -> elem(x, 0) end)
    result = {true, hand_result}
    result
  end

end