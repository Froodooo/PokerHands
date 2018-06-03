defmodule PokerHands.Rankers.HighCardRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  alias PokerHands.Helpers.RankerHelper, as: RankerHelper
  @behaviour HandRanker

  def rank(hand) do
    hand_order_indexed = CardHelper.get_hand_order_indexed(hand)
    all_highest_orders_indices = get_highest_order_indices(hand_order_indexed)
    hand_indexed = Enum.with_index(hand)
    result = CardHelper.get_hand_result(hand_indexed, all_highest_orders_indices)
    result
  end

  def tie(hand_black, hand_white) do
    {hand_black_order, hand_white_order} = CardHelper.get_hand_order(hand_black, hand_white)
    {black_values_ordered, white_values_ordered} = RankerHelper.get_hand_values(hand_black_order, hand_white_order)

    if (RankerHelper.hands_are_equal(black_values_ordered, white_values_ordered)) do
      :tie
    else
      RankerHelper.compare(black_values_ordered, white_values_ordered)
    end
  end

  defp get_highest_order_indices(hand_order_indexed) do
    highest_order = Enum.max_by(hand_order_indexed, fn x -> elem(x, 0) end)

    all_highest_orders =
      Enum.filter(hand_order_indexed, fn x -> elem(x, 0) == elem(highest_order, 0) end)

    all_highest_orders_indices = Enum.map(all_highest_orders, fn x -> elem(x, 1) end)
    all_highest_orders_indices
  end
end
