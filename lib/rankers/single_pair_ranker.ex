defmodule PokerHands.Rankers.SinglePairRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider
  alias PokerHands.Helpers.SetProvider, as: SetProvider
  alias PokerHands.Rankers.HighCardRanker, as: HighCardRanker
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
      :tie -> HighCardRanker.tie(hand_black, hand_white)
      _ -> result
    end
  end

  defp get_highest_pair(hand_black, hand_white) do
    black_card_values = CardValueProvider.get_card_values_indexed(elem(hand_black, 1))
    white_card_values = CardValueProvider.get_card_values_indexed(elem(hand_white, 1))

    card_value_black = elem(Enum.at(black_card_values, 0), 0)
    card_value_white = elem(Enum.at(white_card_values, 0), 0)

    cond do
      card_value_black > card_value_white -> :black
      card_value_white > card_value_black -> :white
      true -> :tie
    end
  end
end
