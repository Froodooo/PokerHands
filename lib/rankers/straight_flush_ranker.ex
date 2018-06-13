defmodule PokerHands.Rankers.StraightFlushRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Rankers.StraightRanker, as: StraightRanker
  alias PokerHands.Rankers.FlushRanker, as: FlushRanker
  alias PokerHands.Rankers.HighCardRanker, as: HighCardRanker
  @behaviour HandRanker

  @doc ~S"""
  Ranks the given hand and returns true if it's a straight flush.

  ## Examples
      iex> PokerHands.Rankers.StraightFlushRanker.rank([{:"3", :S}, {:"2", :S}, {:"5", :S}, {:"6", :S}, {:"4", :S}])
      {true, [{:"3", :S}, {:"2", :S}, {:"5", :S}, {:"6", :S}, {:"4", :S}]}
  """
  def rank(hand) do
    is_straight = elem(StraightRanker.rank(hand), 0)
    is_flush = elem(FlushRanker.rank(hand), 0)

    rank =
      if is_straight && is_flush,
        do: {true, hand},
        else: {false, hand}

    rank
  end

  @doc ~S"""
  Ranks the tied straight flush hands and returns the winner (if any).

  ## Examples
      iex> PokerHands.Rankers.StraightFlushRanker.tie(
      ...> {["7": :H, "8": :H, "T": :H, Q: :H, J: :H], ["7": :H, "8": :H, "T": :H, Q: :H, J: :H]},
      ...> {["9": :S, K: :S, T: :S, Q: :S, J: :S], ["9": :S, K: :S, T: :S, Q: :S, J: :S]})
      {:white, [K: :S]}
  """
  def tie(hand_black, hand_white) do
    winner = HighCardRanker.tie(hand_black, hand_white)
    winner
  end
end
