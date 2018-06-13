defmodule PokerHands.Rankers.TwoPairRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.HandComparer, as: HandComparer
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider
  alias PokerHands.Helpers.SetProvider, as: SetProvider
  alias PokerHands.Rankers.HighCardRanker, as: HighCardRanker
  @behaviour HandRanker

  @doc ~S"""
  Ranks the given hand and returns true if it's a two pair.

  ## Examples
      iex> PokerHands.Rankers.TwoPairRanker.rank([{:"2", :H}, {:"3", :D}, {:"2", :S}, {:"3", :C}, {:K, :D}])
      {true, [{:"2", :H}, {:"3", :D}, {:"2", :S}, {:"3", :C}]}
  """
  def rank(hand) do
    sets = SetProvider.get_card_value_sets(hand, 2)

    rank =
      if Enum.count(sets) == 2 do
        sets_indices = get_card_sets_indices(sets)
        hand_indexed = Enum.with_index(hand)
        CardValueProvider.get_cards_with_highest_order(hand_indexed, sets_indices)
      else
        {false, []}
      end

    rank
  end

  def tie(hand_black, hand_white) do
    highest_pair = get_highest_pair(elem(hand_black, 1), elem(hand_white, 1))

    winner =
      case highest_pair do
        {:tie, _} -> HighCardRanker.tie(hand_black, hand_white)
        _ -> highest_pair
      end

    winner
  end

  def get_highest_pair(hand_black, hand_white) do
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
    
    highest_pair = case rank do
      :tie -> {:tie, nil}
      :black -> {:black, [Enum.at(hand_black, highest_pair_index)]}
      :white -> {:white, [Enum.at(hand_white, highest_pair_index)]}
    end

    highest_pair
  end

  defp get_card_sets_indices(sets) do
    sets_indices =
      Enum.flat_map(sets, fn x -> x end)
      |> Enum.map(fn x -> elem(x, 1) end)

    sets_indices
  end
end
