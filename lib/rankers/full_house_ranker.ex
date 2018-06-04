defmodule PokerHands.Rankers.FullHouseRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  alias PokerHands.Helpers.RankerHelper, as: RankerHelper
  @behaviour HandRanker

  def rank(hand) do
    suits_3 = CardHelper.get_suit(hand, 3)
    suits_2 = CardHelper.get_suit(hand, 2)
    if Enum.count(suits_3) == 1 && Enum.count(suits_2) == 1, do: {true, hand}, else: {false, []}
  end

  def tie(hand_black, hand_white) do
    hand_black_full_house = elem(hand_black, 1)
    hand_white_full_house = elem(hand_white, 1)

    IO.puts("test 2342")

    hand_black_suits_3 = CardHelper.get_suit(hand_black_full_house, 3)
    hand_white_suits_3 = CardHelper.get_suit(hand_white_full_house, 3)

    black_card_values =
      List.flatten(Enum.map(hand_black_suits_3, fn x -> CardHelper.get_card_values(x) end))

    white_card_values =
      List.flatten(Enum.map(hand_white_suits_3, fn x -> CardHelper.get_card_values(x) end))

    black_card_values_sorted = Enum.sort(black_card_values, &(&1 >= &2))
    white_card_values_sorted = Enum.sort(white_card_values, &(&1 >= &2))

    if RankerHelper.hands_are_equal(black_card_values_sorted, white_card_values_sorted) do
      :tie
    else
      RankerHelper.compare_card_values(black_card_values_sorted, white_card_values_sorted)
    end
  end
end
