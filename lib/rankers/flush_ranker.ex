defmodule PokerHands.Rankers.FlushRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  alias PokerHands.Rankers.HighCardRanker, as: HighCardRanker
  @behaviour HandRanker

  def rank(hand) do
    suits = CardHelper.get_suit(hand, 5)

    rank =
      if Enum.count(suits) == 1,
        do: {true, hand},
        else: {false, []}

    rank
  end

  def tie(hand_black, hand_white) do
    winner = HighCardRanker.tie(hand_black, hand_white)
    winner
  end
end
