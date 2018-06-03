defmodule PokerHands.Rankers.FullHouseRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  @behaviour HandRanker

  def rank(hand) do
    suits_3 = CardHelper.get_suit(hand, 3)
    suits_2 = CardHelper.get_suit(hand, 2)
    if Enum.count(suits_3) == 1 && Enum.count(suits_2) == 1, do: {true, hand}, else: {false, []}
  end

  def tie(atom, hand) do
    {:tie, atom, hand}
  end
end
