defmodule PokerHands.Rankers.HighCardRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  @behaviour HandRanker

  def rank(hand) do
    hand_order = Enum.map(hand, fn(x) -> CardHelper.get_card_value_order(elem(x, 0)) end)
    hand_order_with_index = Enum.with_index(hand_order)
    highest_order = Enum.max_by(hand_order_with_index, fn(x) -> elem(x, 0) end)
    all_highest_orders = Enum.filter(hand_order_with_index, fn(x) -> elem(x, 0) == elem(highest_order, 0) end)
    all_highest_orders_indices = Enum.map(all_highest_orders, fn(x) -> elem(x, 1) end)
    
    hand_with_index = Enum.with_index(hand)
    hand_result_with_index = Enum.filter(hand_with_index, fn(x) -> elem(x, 1) in all_highest_orders_indices end)
    hand_result = Enum.map(hand_result_with_index, fn(x) -> elem(x, 0) end)
    result = {true, hand_result}
    result
  end

end