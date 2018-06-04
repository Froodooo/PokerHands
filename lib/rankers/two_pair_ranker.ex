defmodule PokerHands.Rankers.TwoPairRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  alias PokerHands.Helpers.RankerHelper, as: RankerHelper
  @behaviour HandRanker

  def rank(hand) do
    sets = CardHelper.get_sets(hand, 2)

    rank =
      if Enum.count(sets) == 2 do
        sets_indices = get_sets_indices(sets)
        hand_indexed = Enum.with_index(hand)
        CardHelper.get_hand_result(hand_indexed, sets_indices)
      else
        {false, []}
      end

    rank
  end

  def tie(hand_black, hand_white) do
    {hand_black_pairs, hand_white_pairs} = {elem(hand_black, 1), elem(hand_white, 1)}
    highest_pair = get_highest_pair(hand_black_pairs, hand_white_pairs)

    winner =
      case highest_pair do
        :tie -> get_highest_value(hand_black, hand_white)
        _ -> highest_pair
      end

    winner
  end

  def get_highest_pair(hand_black, hand_white) do
    {black_card_values, white_card_values} =
      {CardHelper.get_card_values(hand_black), CardHelper.get_card_values(hand_white)}

    {black_card_values_sorted, white_card_values_sorted} =
      {Enum.sort(black_card_values, &(&1 >= &2)), Enum.sort(white_card_values, &(&1 >= &2))}

    {black_card_values_sorted_dedupped, white_card_values_sorted_dedupped} =
      {Enum.dedup(black_card_values_sorted), Enum.dedup(white_card_values_sorted)}

    highest_pair =
      if RankerHelper.hands_are_equal(
           black_card_values_sorted_dedupped,
           white_card_values_sorted_dedupped
         ) do
        :tie
      else
        RankerHelper.compare_card_values(
          black_card_values_sorted_dedupped,
          white_card_values_sorted_dedupped
        )
      end

    highest_pair
  end

  defp get_highest_value(hand_black, hand_white) do
    {black_card_values, white_card_values} = CardHelper.get_card_values(hand_black, hand_white)

    {black_card_values_ordered, white_card_values_ordered} =
      RankerHelper.get_hand_values(black_card_values, white_card_values)

    highest_value =
      if RankerHelper.hands_are_equal(black_card_values_ordered, white_card_values_ordered) do
        :tie
      else
        RankerHelper.compare_card_values(black_card_values_ordered, white_card_values_ordered)
      end

    highest_value
  end

  defp get_sets_indices(sets) do
    sets_indices =
      Enum.flat_map(sets, fn x -> x end)
      |> Enum.map(fn x -> elem(x, 1) end)

    sets_indices
  end
end
