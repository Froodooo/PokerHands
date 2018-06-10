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
    sets = SetProvider.get_card_sets(hand, 2)

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
        :tie -> HighCardRanker.tie(hand_black, hand_white)
        _ -> highest_pair
      end

    winner
  end

  def get_highest_pair(hand_black, hand_white) do
    black_card_values =
      CardValueProvider.get_card_values(hand_black)
      |> Enum.sort(&(&1 >= &2))
      |> Enum.dedup()

    white_card_values =
      CardValueProvider.get_card_values(hand_white)
      |> Enum.sort(&(&1 >= &2))
      |> Enum.dedup()

    highest_pair =
      if HandComparer.hands_are_equal(black_card_values, white_card_values),
        do: :tie,
        else: HandComparer.get_player_with_highest_card(black_card_values, white_card_values)

    highest_pair
  end

  defp get_card_sets_indices(sets) do
    sets_indices =
      Enum.flat_map(sets, fn x -> x end)
      |> Enum.map(fn x -> elem(x, 1) end)

    sets_indices
  end
end
