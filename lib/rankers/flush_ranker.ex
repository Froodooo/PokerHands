defmodule PokerHands.Rankers.FlushRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Rankers.HighCardRanker, as: HighCardRanker
  alias PokerHands.Helpers.SuitProvider, as: SuitProvider
  @behaviour HandRanker

  @doc ~S"""
  Ranks the given hand and returns true if it's a flush.

  ## Examples
      iex> PokerHands.Rankers.FlushRanker.rank([{:"2", :S}, {:"3", :S}, {:"4", :S}, {:"5", :S}, {:"6", :S}])
      {true, [{:"2", :S}, {:"3", :S}, {:"4", :S}, {:"5", :S}, {:"6", :S}]}
  """
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
