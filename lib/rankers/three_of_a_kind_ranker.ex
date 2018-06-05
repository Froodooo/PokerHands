defmodule PokerHands.Rankers.ThreeOfAKindRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider
  alias PokerHands.Helpers.SetProvider, as: SetProvider
  @behaviour HandRanker

  def rank(hand) do
    sets = SetProvider.get_sets(hand, 3)

    rank =
      if Enum.count(sets) == 0,
        do: {false, []},
        else: get_three_of_a_kind_hand_result(sets, hand)

    rank
  end

  def tie(hand_black, hand_white) do
    winner = CardValueProvider.get_highest_set_value(hand_black, hand_white)
    winner
  end

  defp get_three_of_a_kind_hand_result(sets, hand) do
    sets_indices = SetProvider.get_sets_indices(sets)
    hand_indexed = Enum.with_index(hand)
    CardValueProvider.get_hand_result(hand_indexed, sets_indices)
  end
end
