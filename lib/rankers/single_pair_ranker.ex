defmodule PokerHands.Rankers.SinglePairRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.HandComparer, as: HandComparer
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider
  alias PokerHands.Helpers.SetProvider, as: SetProvider
  @behaviour HandRanker

  def rank(hand) do
    sets = SetProvider.get_sets(hand, 2)

    result =
      if Enum.count(sets) == 0 do
        {false, []}
      else
        sets_indices = SetProvider.get_sets_indices(sets)

        Enum.with_index(hand)
        |> CardValueProvider.get_hand_result(sets_indices)
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
      {CardValueProvider.get_card_values_indexed(pair_black),
       CardValueProvider.get_card_values_indexed(pair_white)}

    {card_value_black, card_value_white} =
      {elem(Enum.at(black_card_values, 0), 0), elem(Enum.at(white_card_values, 0), 0)}

    cond do
      card_value_black > card_value_white -> :black
      card_value_white > card_value_black -> :white
      true -> :tie
    end
  end

  defp get_highest_value(hand_black, hand_white) do
    {black_card_values, white_card_values} =
      CardValueProvider.get_card_values(hand_black, hand_white)

    {black_card_values_ordered, white_card_values_ordered} =
      CardValueProvider.get_hand_values(black_card_values, white_card_values)

    if HandComparer.hands_are_equal(black_card_values_ordered, white_card_values_ordered) do
      :tie
    else
      HandComparer.compare_card_values(black_card_values_ordered, white_card_values_ordered)
    end
  end
end
