defmodule PokerHands.Helpers.RankerHelper do
  alias PokerHands.Rankers.StraightFlushRanker, as: StraightFlushRanker
  alias PokerHands.Rankers.FourOfAKindRanker, as: FourOfAKindRanker
  alias PokerHands.Rankers.FullHouseRanker, as: FullHouseRanker
  alias PokerHands.Rankers.FlushRanker, as: FlushRanker
  alias PokerHands.Rankers.StraightRanker, as: StraightRanker
  alias PokerHands.Rankers.ThreeOfAKindRanker, as: ThreeOfAKindRanker
  alias PokerHands.Rankers.TwoPairRanker, as: TwoPairRanker
  alias PokerHands.Rankers.SinglePairRanker, as: SinglePairRanker
  alias PokerHands.Rankers.HighCardRanker, as: HighCardRanker

  def get_highest_rank(black_rank, white_rank) do
    black_rank_order = get_rank_order(black_rank)
    white_rank_order = get_rank_order(white_rank)

    result = :tie
    result = if black_rank_order > white_rank_order, do: :black, else: result
    result = if white_rank_order > black_rank_order, do: :white, else: result
    result
  end

  def get_rank_tie_function(rank_atom) do
    case rank_atom do
      :high_card -> &HighCardRanker.tie/2
      :single_pair -> &SinglePairRanker.tie/2
      :two_pair -> &TwoPairRanker.tie/2
      :three_of_a_kind -> &ThreeOfAKindRanker.tie/2
      :straight -> &StraightRanker.tie/2
      :flush -> &FlushRanker.tie/2
      :full_house -> &FullHouseRanker.tie/2
      :four_of_a_kind -> &FourOfAKindRanker.tie/2
      :straight_flush -> &StraightFlushRanker.tie/2
    end
  end

  defp get_rank_order(rank) do
    rank_atom = elem(rank, 0)

    case rank_atom do
      :high_card -> 1
      :single_pair -> 2
      :two_pair -> 3
      :three_of_a_kind -> 4
      :straight -> 5
      :flush -> 6
      :full_house -> 7
      :four_of_a_kind -> 8
      :straight_flush -> 9
    end
  end
end
