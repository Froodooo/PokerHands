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

  @doc ~S"""
  Ranks the tied three of a kind hands and returns the winner (if any).

  ## Examples
      iex> PokerHands.Rankers.ThreeOfAKindRanker.tie(
      ...> {[K: :H, K: :C, "5": :S, A: :C, K: :D], [K: :H, K: :C, K: :D]},
      ...> {[Q: :C, "3": :H, Q: :S, Q: :D, K: :H], [Q: :C, Q: :S, Q: :D]})
      {:black, [K: :H, K: :C, K: :D]}
  """
  def tie(hand_black, hand_white) do
    {_, black_cards_ranked} = hand_black
    {_, white_cards_ranked} = hand_white

    winner =
      CardValueProvider.get_card_with_highest_set_value(black_cards_ranked, white_cards_ranked)

    winner
  end

  defp get_three_of_a_kind_hand_result(sets, hand) do
    sets_indices = SetProvider.get_card_sets_indices(sets)
    hand_indexed = Enum.with_index(hand)
    CardValueProvider.get_cards_with_highest_order(hand_indexed, sets_indices)
  end
end
