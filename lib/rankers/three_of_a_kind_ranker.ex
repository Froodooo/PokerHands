defmodule PokerHands.Rankers.ThreeOfAKindRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider
  alias PokerHands.Helpers.SetProvider, as: SetProvider
  @behaviour HandRanker

  @doc ~S"""
  Ranks the given hand and returns true if it's a three of a kind.

  ## Examples
      iex> PokerHands.Rankers.ThreeOfAKindRanker.rank([{:"2", :H}, {:"3", :D}, {:"2", :S}, {:"3", :C}, {:"2", :D}])
      {true, [{:"2", :H}, {:"2", :S}, {:"2", :D}]}
  """
  def rank(hand) do
    sets = SetProvider.get_card_value_sets(hand, 3)

    rank =
      if Enum.count(sets) == 0,
        do: {false, []},
        else: get_three_of_a_kind_hand_result(sets, hand)

    rank
  end

  def tie(hand_black, hand_white) do
    winner = CardValueProvider.get_card_with_highest_set_value(hand_black, hand_white)
    winner
  end

  defp get_three_of_a_kind_hand_result(sets, hand) do
    sets_indices = SetProvider.get_card_sets_indices(sets)
    hand_indexed = Enum.with_index(hand)
    CardValueProvider.get_cards_with_highest_order(hand_indexed, sets_indices)
  end
end
