defmodule PokerHands.Rankers.StraightRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  @behaviour HandRanker

  def rank(hand) do
    hand_order_indexed = CardHelper.get_hand_order_indexed(hand)
    hand_values = Enum.map(hand_order_indexed, fn x -> elem(x, 0) end)
    hand_values_ordered = Enum.sort(hand_values)

    iterations = is_increasing_list(hand_values_ordered, hd(hand_values_ordered), 0)
    if iterations == Enum.count(hand), do: {true, hand}, else: {false, []}
  end

  def tie(hand_black, hand_white) do
    hand_black_straight = elem(hand_black, 1)
    hand_white_straight = elem(hand_white, 1)

    hand_black_order = CardHelper.get_hand_order(hand_black_straight)
    hand_white_order = CardHelper.get_hand_order(hand_white_straight)

    hand_black_order_sorted = Enum.sort(hand_black_order, &(&1 >= &2))
    hand_white_order_sorted = Enum.sort(hand_white_order, &(&1 >= &2))

    value_black = Enum.at(hand_black_order_sorted, 0)
    value_white = Enum.at(hand_white_order_sorted, 0)

    cond do
      value_black > value_white -> :black
      value_white > value_black -> :white
      true -> :tie
    end
  end

  defp is_increasing_list(list, v, n) when tl(list) == [] do
    if hd(list) == v, do: n + 1, else: n
  end

  defp is_increasing_list(list, v, n) do
    n = if hd(list) == v, do: n + 1, else: n
    is_increasing_list(tl(list), v + 1, n)
  end
end
