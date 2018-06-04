defmodule PokerHands.Rankers.StraightFlushRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Rankers.StraightRanker, as: StraightRanker
  alias PokerHands.Rankers.FlushRanker, as: FlushRanker
  alias PokerHands.Rankers.HighCardRanker, as: HighCardRanker
  @behaviour HandRanker

  def rank(hand) do
    is_straight = elem(StraightRanker.rank(hand), 0)
    is_flush = elem(FlushRanker.rank(hand), 0)

    rank =
      if is_straight && is_flush,
        do: {true, hand},
        else: {false, hand}

    rank
  end

  def tie(hand_black, hand_white) do
    winner = HighCardRanker.tie(hand_black, hand_white)
    winner
  end
end
