defmodule PokerHands.Rankers.StraightFlushRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Rankers.StraightRanker, as: StraightRanker
  alias PokerHands.Rankers.FlushRanker, as: FlushRanker
  @behaviour HandRanker

  def rank(hand) do
    is_straight = elem(StraightRanker.rank(hand), 0)
    is_flush = elem(FlushRanker.rank(hand), 0)
    if is_straight && is_flush, do: {true, hand}, else: {false, hand}
  end

  def tie(hand_black, hand_white) do
    {:tie, hand_black, hand_white}
  end
end
