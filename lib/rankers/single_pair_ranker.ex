defmodule PokerHands.Rankers.SinglePairRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  alias PokerHands.Helpers.RankerHelper, as: RankerHelper
  @behaviour HandRanker

  def rank(hand) do
    sets = CardHelper.get_sets(hand, 2)

    result =
      if Enum.count(sets) == 0 do
        {false, []}
      else
        sets_indices = CardHelper.get_sets_indices(sets)

        Enum.with_index(hand)
        |> CardHelper.get_hand_result(sets_indices)
      end

    result
  end

  def tie(hand_black, hand_white) do
    result = get_highest_pair(hand_black, hand_white)

    case result do
      :tie -> get_highest_value(hand_black, hand_white)
      _ -> result
    end
  end

  defp get_highest_pair(hand_black, hand_white) do
    {pair_black, pair_white} = {elem(hand_black, 1), elem(hand_white, 1)}

    {black_card_values, white_card_values} =
      {CardHelper.get_card_values_indexed(pair_black),
       CardHelper.get_card_values_indexed(pair_white)}

    {card_value_black, card_value_white} =
      {elem(Enum.at(black_card_values, 0), 0), elem(Enum.at(white_card_values, 0), 0)}

    cond do
      card_value_black > card_value_white -> :black
      card_value_white > card_value_black -> :white
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
