defmodule PokerHands.Rankers.FourOfAKindRanker do
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider
  alias PokerHands.Helpers.SetProvider, as: SetProvider
  alias PokerHands.Rankers.ThreeOfAKindRanker, as: ThreeOfAKindRanker

  @doc ~S"""
  Ranks the given hand and returns true if it's a four of a kind.

  ## Examples
      iex> PokerHands.Rankers.FourOfAKindRanker.rank([{:"2", :H}, {:"3", :D}, {:"2", :S}, {:"2", :C}, {:"2", :D}])
      {true, [{:"2", :H}, {:"2", :S}, {:"2", :C}, {:"2", :D}]}
  """
  def rank(hand) do
    sets = SetProvider.get_card_value_sets(hand, 4)

    rank =
      if Enum.count(sets) == 0 do
        {false, []}
      else
        sets_indices = SetProvider.get_card_sets_indices(sets)
        hand_indexed = Enum.with_index(hand)
        result = CardValueProvider.get_cards_with_highest_order(hand_indexed, sets_indices)
        result
      end

    rank
  end

  @doc ~S"""
  Ranks the tied four of a kind hands and returns the winner (if any).

  ## Examples
      iex> PokerHands.Rankers.FourOfAKindRanker.tie(
      ...> {["7": :H, "7": :S, "7": :D, J: :H, "7": :C], ["7": :H, "7": :S, "7": :D, "7": :C]},
      ...> {["9": :H, K: :S, "9": :S, "9": :D, "9": :C], ["9": :H, "9": :S, "9": :D, "9": :C]})
      {:white, ["9": :H, "9": :S, "9": :D, "9": :C]}
  """
  def tie(hand_black, hand_white) do
    winner = ThreeOfAKindRanker.tie(hand_black, hand_white)
    winner
  end
end
