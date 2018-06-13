defmodule PokerHands.Rankers.FullHouseRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.HandComparer, as: HandComparer
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider
  alias PokerHands.Helpers.SetProvider, as: SetProvider
  @behaviour HandRanker

  @high_set_size 3
  @low_set_size 2
  @set_count 1

  @doc ~S"""
  Ranks the given hand and returns true if it's a full house.

  ## Examples
      iex> PokerHands.Rankers.FullHouseRanker.rank([{:"2", :S}, {:"2", :D}, {:"2", :H}, {:"5", :C}, {:"5", :D}])
      {true, [{:"2", :S}, {:"2", :D}, {:"2", :H}, {:"5", :C}, {:"5", :D}]}
  """
  def rank(hand) do
    {sets_3, sets_2} =
      {SetProvider.get_card_sets(hand, @high_set_size),
       SetProvider.get_card_sets(hand, @low_set_size)}

    if Enum.count(sets_3) == @set_count && Enum.count(sets_2) == @set_count,
      do: {true, hand},
      else: {false, []}
  end

  @doc ~S"""
  Ranks the tied full house hands and returns the winner (if any).

  ## Examples
      iex> PokerHands.Rankers.FullHouseRanker.tie(
      ...> {["7": :H, "7": :S, J: :H, "7": :H, J: :C], ["7": :H, "7": :S, J: :H, "7": :H, J: :C]},
      ...> {[K: :H, K: :S, "4": :H, K: :D, "4": :S], [K: :H, K: :S, "4": :H, K: :D, "4": :S]})
      {:white, [K: :H, K: :S, "4": :H, K: :D, "4": :S]}
  """
  def tie(hand_black, hand_white) do
    {_, black_hand_ranked} = hand_black
    {_, white_hand_ranked} = hand_white
    hand_black_sets_3 = SetProvider.get_card_sets(black_hand_ranked, @high_set_size)
    hand_white_sets_3 = SetProvider.get_card_sets(white_hand_ranked, @high_set_size)

    black_card_values_sorted =
      Enum.map(hand_black_sets_3, fn x -> CardValueProvider.get_card_values(x) end)
      |> List.flatten()
      |> Enum.sort(&(&1 >= &2))

    white_card_values_sorted =
      Enum.map(hand_white_sets_3, fn x -> CardValueProvider.get_card_values(x) end)
      |> List.flatten()
      |> Enum.sort(&(&1 >= &2))

    winner =
      if HandComparer.hands_are_equal(black_card_values_sorted, white_card_values_sorted) do
        {:tie, nil}
      else
        {HandComparer.compare_hands(black_card_values_sorted, white_card_values_sorted), nil}
      end

    case winner do
      {:tie, _} -> winner
      {:black, _} -> {:black, black_hand_ranked}
      {:white, _} -> {:white, white_hand_ranked}
    end
  end
end
