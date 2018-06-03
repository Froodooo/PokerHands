defmodule PokerHands.Rankers.HighCardRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  @behaviour HandRanker

  def rank(hand) do
    hand_order_indexed = CardHelper.get_hand_order_indexed(hand)
    all_highest_orders_indices = get_highest_order_indices(hand_order_indexed)
    hand_indexed = Enum.with_index(hand)
    result = CardHelper.get_hand_result(hand_indexed, all_highest_orders_indices)
    result
  end

  def tie(hand_black, hand_white) do
    hand_black_compare = elem(hand_black, 0)
    hand_white_compare = elem(hand_white, 0)

    hand_black_compare_order = CardHelper.get_hand_order_indexed(hand_black_compare)
    hand_white_compare_order = CardHelper.get_hand_order_indexed(hand_white_compare)

    black_values = Enum.map(hand_black_compare_order, fn(x) -> elem(x, 0) end)
    white_values = Enum.map(hand_white_compare_order, fn(x) -> elem(x, 0) end)

    black_values_ordered = Enum.sort(black_values, &(&1 >= &2))
    white_values_ordered = Enum.sort(white_values, &(&1 >= &2))

    if (hands_are_equal(black_values_ordered, white_values_ordered)) do
      :tie
    else
      compare(black_values_ordered, white_values_ordered)
    end
  end

  defp hands_are_equal(hand_black, hand_white) do
    hand_zipped = Enum.zip(hand_black, hand_white)
    hands_are_equal = Enum.all?(hand_zipped, fn(x) -> elem(x, 0) == elem(x, 1) end)
    hands_are_equal
  end

  defp compare(hand_black, hand_white) do
    head_black = hd(hand_black)
    head_white = hd(hand_white)

    cond do
      head_black > head_white -> :black
      head_white > head_black -> :white
      true -> compare(tl(hand_black), tl(hand_white))
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
