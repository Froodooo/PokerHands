defmodule PokerHands.Rankers.TwoPairRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.HandComparer, as: HandComparer
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider
  alias PokerHands.Helpers.SetProvider, as: SetProvider
  alias PokerHands.Rankers.HighCardRanker, as: HighCardRanker
  @behaviour HandRanker

  @two_pair_size 2
  @set_count 2

  @doc ~S"""
  Ranks the given hand and returns true if it's a two pair.

  ## Examples
      iex> PokerHands.Rankers.TwoPairRanker.rank([{:"2", :H}, {:"3", :D}, {:"2", :S}, {:"3", :C}, {:K, :D}])
      {true, [{:"2", :H}, {:"3", :D}, {:"2", :S}, {:"3", :C}]}
  """
  def rank(hand) do
    sets = SetProvider.get_card_value_sets(hand, @two_pair_size)

    if Enum.count(sets) == @set_count do
      sets_indices = get_card_sets_indices(sets)
      hand_indexed = Enum.with_index(hand)
      CardValueProvider.get_cards_with_highest_order(hand_indexed, sets_indices)
    else
      {false, []}
    end
  end

  @doc ~S"""
  Ranks the tied two pair hands and returns the winner (if any).

  ## Examples
      iex> PokerHands.Rankers.TwoPairRanker.tie(
      ...> {["2": :H, "3": :D, "2": :S, "9": :C, "3": :D], ["2": :H, "3": :D, "2": :S, "3": :D]},
      ...> {[K: :C, "3": :H, "4": :S, "3": :C, "4": :H], ["3": :H, "4": :S, "3": :C, "4": :H]})
      {:white, ["4": :S]}
  """
  def tie(hand_black, hand_white) do
    {_, black_hand_ranked} = hand_black
    {_, white_hand_ranked} = hand_white
    highest_pair = get_highest_pair(black_hand_ranked, white_hand_ranked)

    case highest_pair do
      {:tie, _} -> HighCardRanker.tie(hand_black, hand_white)
      _ -> highest_pair
    end
  end

  defp get_highest_pair(hand_black, hand_white) do
    black_card_values =
      CardValueProvider.get_card_values_indexed(hand_black)
      |> Enum.sort(&(elem(&1, 0) >= elem(&2, 0)))
      |> Enum.dedup()

    white_card_values =
      CardValueProvider.get_card_values_indexed(hand_white)
      |> Enum.sort(&(elem(&1, 0) >= elem(&2, 0)))
      |> Enum.dedup()

    {rank, highest_pair_index} =
      if HandComparer.hands_are_equal(black_card_values, white_card_values),
        do: {:tie, nil},
        else: HandComparer.compare_hands_indexed(black_card_values, white_card_values)

    case rank do
      :tie -> {:tie, nil}
      :black -> {:black, [Enum.at(hand_black, highest_pair_index)]}
      :white -> {:white, [Enum.at(hand_white, highest_pair_index)]}
    end
  end

  defp get_card_sets_indices(sets) do
    Enum.flat_map(sets, fn x -> x end)
    |> Enum.map(fn {_, x} -> x end)
  end
end
