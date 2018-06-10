defmodule PokerHands.Rankers.FullHouseRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.HandComparer, as: HandComparer
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider
  alias PokerHands.Helpers.SuitProvider, as: SuitProvider
  @behaviour HandRanker

  @doc ~S"""
  Ranks the given hand and returns true if it's a full house.

  ## Examples
      iex> PokerHands.Rankers.FullHouseRanker.rank([{:"2", :S}, {:"3", :S}, {:"4", :S}, {:"5", :C}, {:"6", :C}])
      {true, [{:"2", :S}, {:"3", :S}, {:"4", :S}, {:"5", :C}, {:"6", :C}]}
  """
  def rank(hand) do
    {suits_3, suits_2} = {SuitProvider.get_suit(hand, 3), SuitProvider.get_suit(hand, 2)}

    rank =
      if Enum.count(suits_3) == 1 && Enum.count(suits_2) == 1,
        do: {true, hand},
        else: {false, []}

    rank
  end

  def tie(hand_black, hand_white) do
    hand_black_suits_3 = SuitProvider.get_suit(elem(hand_black, 1), 3)
    hand_white_suits_3 = SuitProvider.get_suit(elem(hand_white, 1), 3)

    black_card_values_sorted =
      Enum.map(hand_black_suits_3, fn x -> CardValueProvider.get_card_values(x) end)
      |> List.flatten()
      |> Enum.sort(&(&1 >= &2))

    white_card_values_sorted =
      Enum.map(hand_white_suits_3, fn x -> CardValueProvider.get_card_values(x) end)
      |> List.flatten()
      |> Enum.sort(&(&1 >= &2))

    winner =
      if HandComparer.hands_are_equal(black_card_values_sorted, white_card_values_sorted) do
        {:tie, nil}
      else
        {HandComparer.compare_hands(black_card_values_sorted, white_card_values_sorted), nil}
      end

    winner
  end
end
