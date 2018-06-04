defmodule PokerHands.Rankers.HighCardRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.HandComparer, as: HandComparer
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider
  @behaviour HandRanker

  def rank(hand) do
    highest_card_values =
      CardValueProvider.get_card_values_indexed(hand)
      |> get_highest_card_values()

    result =
      Enum.with_index(hand)
      |> CardValueProvider.get_hand_result(highest_card_values)

    result
  end

  def tie(hand_black, hand_white) do
    {black_card_values, white_card_values} =
      CardValueProvider.get_card_values(hand_black, hand_white)

    {black_card_values_ordered, white_card_values_ordered} =
      CardValueProvider.get_hand_values(black_card_values, white_card_values)

    result =
      if HandComparer.hands_are_equal(black_card_values_ordered, white_card_values_ordered),
        do: :tie,
        else:
          HandComparer.compare_card_values(black_card_values_ordered, white_card_values_ordered)

    result
  end

  defp get_highest_card_values(card_values) do
    highest_card_value = Enum.max_by(card_values, fn x -> elem(x, 0) end)

    all_highest_card_values =
      Enum.filter(card_values, fn x -> elem(x, 0) == elem(highest_card_value, 0) end)
      |> Enum.map(fn x -> elem(x, 1) end)

    all_highest_card_values
  end
end
