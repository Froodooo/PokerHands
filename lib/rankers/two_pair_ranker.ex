defmodule PokerHands.Rankers.TwoPairRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  alias PokerHands.Helpers.RankerHelper, as: RankerHelper
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
    hand_black_pairs = elem(hand_black, 1)
    hand_white_pairs = elem(hand_white, 1)
    result = get_highest_pair(hand_black_pairs, hand_white_pairs)

    case result do
      :tie -> get_highest_value(hand_black, hand_white)
      _ -> result
    end
  end

  def get_highest_pair(hand_black, hand_white) do    
    hand_black_pairs_values = CardHelper.get_hand_order(hand_black)
    hand_white_pairs_values = CardHelper.get_hand_order(hand_white)

    hand_black_pairs_values_ordered = Enum.sort(hand_black_pairs_values, &(&1 >= &2))
    hand_white_pairs_values_ordered = Enum.sort(hand_white_pairs_values, &(&1 >= &2))

    hand_black_pairs_values_ordered_dedupped = Enum.dedup(hand_black_pairs_values_ordered)
    hand_white_pairs_values_ordered_dedupped = Enum.dedup(hand_white_pairs_values_ordered)

    if (RankerHelper.hands_are_equal(hand_black_pairs_values_ordered_dedupped, hand_white_pairs_values_ordered_dedupped)) do
      :tie
    else
      RankerHelper.compare(hand_black_pairs_values_ordered_dedupped, hand_white_pairs_values_ordered_dedupped)
    end
  end

  defp get_highest_value(hand_black, hand_white) do
    {hand_black_order, hand_white_order} = CardHelper.get_hand_order(hand_black, hand_white)
    {black_values_ordered, white_values_ordered} = RankerHelper.get_hand_values(hand_black_order, hand_white_order)

    if (RankerHelper.hands_are_equal(black_values_ordered, white_values_ordered)) do
      :tie
    else
      RankerHelper.compare(black_values_ordered, white_values_ordered)
    end
  end

  defp get_sets_indices(sets) do
    sets_flat = Enum.flat_map(sets, fn x -> x end)
    sets_indices = Enum.map(sets_flat, fn x -> elem(x, 1) end)
    sets_indices
  end
end
