defmodule PokerHands.Rankers.FlushRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Rankers.HighCardRanker, as: HighCardRanker
  alias PokerHands.Helpers.SuitProvider, as: SuitProvider
  @behaviour HandRanker

  def rank(hand) do
    suits = SuitProvider.get_suit(hand, 5)

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
