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

    IO.puts "test 2342"

    hand_black_suits_3 = CardHelper.get_suit(hand_black_full_house, 3)
    hand_white_suits_3 = CardHelper.get_suit(hand_white_full_house, 3)

    hand_black_order = List.flatten(Enum.map(hand_black_suits_3, fn(x) -> CardHelper.get_hand_order(x) end))
    hand_white_order = List.flatten(Enum.map(hand_white_suits_3, fn(x) -> CardHelper.get_hand_order(x) end))

    hand_black_order_sorted = Enum.sort(hand_black_order, &(&1 >= &2))
    hand_white_order_sorted = Enum.sort(hand_white_order, &(&1 >= &2))

    if (RankerHelper.hands_are_equal(hand_black_order_sorted, hand_white_order_sorted)) do
      :tie
    else
      RankerHelper.compare(hand_black_order_sorted, hand_white_order_sorted)
    end
  end
end
