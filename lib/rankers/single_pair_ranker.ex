defmodule PokerHands.Rankers.SinglePairRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider
  alias PokerHands.Helpers.SetProvider, as: SetProvider
  alias PokerHands.Rankers.HighCardRanker, as: HighCardRanker
  @behaviour HandRanker

  @doc ~S"""
  Ranks the given hand and returns true if it's a single pair.

  ## Examples
      iex> PokerHands.Rankers.SinglePairRanker.rank([{:"2", :H}, {:"3", :D}, {:"2", :S}, {:"9", :C}, {:K, :D}])
      {true, [{:"2", :H}, {:"2", :S}]}
  """
  def rank(hand) do
    sets = SetProvider.get_card_value_sets(hand, 2)

    result =
      if Enum.count(sets) == 0 do
        {false, []}
      else
        sets_indices = SetProvider.get_card_sets_indices(sets)

        Enum.with_index(hand)
        |> CardValueProvider.get_cards_with_highest_order(sets_indices)
      end

    result
  end

  @doc ~S"""
  Ranks the tied single pair hands and returns the winner (if any).

  ## Examples
      iex> PokerHands.Rankers.SinglePairRanker.tie(
      ...> {["2": :H, "3": :D, "2": :S, "9": :C, K: :D], ["2": :H, "2": :S]},
      ...> {["2": :C, "3": :H, "4": :S, "3": :C, A: :H], ["3": :H, "3": :C]})
      {:white, ["3": :H, "3": :C]}
  """
  def tie(hand_black, hand_white) do
    {_, black_cards_ranked} = hand_black
    {_, white_cards_ranked} = hand_white

    result =
      CardValueProvider.get_card_with_highest_set_value(black_cards_ranked, white_cards_ranked)

    winner =
      case result do
        {:tie, _} -> HighCardRanker.tie(hand_black, hand_white)
        _ -> result
      end

    winner
  end
end
