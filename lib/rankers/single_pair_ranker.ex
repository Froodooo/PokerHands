defmodule PokerHands.Rankers.SinglePairRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  alias PokerHands.Helpers.RankerHelper, as: RankerHelper
  @behaviour HandRanker

  def rank(hand) do
    sets = CardHelper.get_sets(hand, 2)

    if Enum.count(sets) == 0 do
      {false, []}
    else
      sets_indices = CardHelper.get_sets_indices(sets)
      hand_indexed = Enum.with_index(hand)
      result = CardHelper.get_hand_result(hand_indexed, sets_indices)
      result
    end
  end

  def tie(hand_black, hand_white) do
    result = get_highest_pair(hand_black, hand_white)

    case result do
      :tie -> get_highest_value(hand_black, hand_white)
      _ -> result
    end
  end

  defp get_highest_pair(hand_black, hand_white) do
    pair_black = elem(hand_black, 1)
    pair_white = elem(hand_white, 1)

    black_card_values = CardHelper.get_card_values_indexed(pair_black)
    white_card_values = CardHelper.get_card_values_indexed(pair_white)

    value_black = elem(Enum.at(black_card_values, 0), 0)
    value_white = elem(Enum.at(white_card_values, 0), 0)

    cond do
      value_black > value_white -> :black
      value_white > value_black -> :white
      true -> :tie
    end
  end

  defp get_highest_value(hand_black, hand_white) do
    {black_card_values, white_card_values} = CardHelper.get_card_values(hand_black, hand_white)

    {black_card_values_ordered, white_card_values_ordered} =
      RankerHelper.get_hand_values(black_card_values, white_card_values)

    if RankerHelper.hands_are_equal(black_card_values_ordered, white_card_values_ordered) do
      :tie
    else
      RankerHelper.compare_card_values(black_card_values_ordered, white_card_values_ordered)
    end
  end
end
