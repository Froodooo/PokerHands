defmodule PokerHands.Rankers.FourOfAKindRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider
  alias PokerHands.Helpers.SetProvider, as: SetProvider
  @behaviour HandRanker

  def rank(hand) do
    sets = SetProvider.get_sets(hand, 4)

    rank =
      if Enum.count(sets) == 0 do
        {false, []}
      else
        sets_indices = SetProvider.get_sets_indices(sets)
        hand_indexed = Enum.with_index(hand)
        result = CardValueProvider.get_hand_result(hand_indexed, sets_indices)
        result
      end

    rank
  end

  def tie(hand_black, hand_white) do
    black_card_values = CardValueProvider.get_card_values_indexed(elem(hand_black, 1))
    white_card_values = CardValueProvider.get_card_values_indexed(elem(hand_white, 1))

    value_black = elem(Enum.at(black_card_values, 0), 0)
    value_white = elem(Enum.at(white_card_values, 0), 0)

    winner =
      cond do
        value_black > value_white -> :black
        value_white > value_black -> :white
        true -> :tie
      end

    winner
  end
end
