defmodule PokerHands.Rankers.CardRanker do
  alias PokerHands.Rankers.StraightFlushRanker, as: StraightFlushRanker
  alias PokerHands.Rankers.FourOfAKindRanker, as: FourOfAKindRanker
  alias PokerHands.Rankers.FullHouseRanker, as: FullHouseRanker
  alias PokerHands.Rankers.FlushRanker, as: FlushRanker
  alias PokerHands.Rankers.StraightRanker, as: StraightRanker
  alias PokerHands.Rankers.ThreeOfAKindRanker, as: ThreeOfAKindRanker
  alias PokerHands.Rankers.TwoPairRanker, as: TwoPairRanker
  alias PokerHands.Rankers.SinglePairRanker, as: SinglePairRanker
  alias PokerHands.Rankers.HighCardRanker, as: HighCardRanker

  def rank(hand) do
    rank = nil
    rank = rank_with_ranker(&StraightFlushRanker.rank/1, rank, hand, :straight_flush)
    rank = rank_with_ranker(&FourOfAKindRanker.rank/1, rank, hand, :four_of_a_kind)
    rank = rank_with_ranker(&FullHouseRanker.rank/1, rank, hand, :full_house)
    rank = rank_with_ranker(&FlushRanker.rank/1, rank, hand, :flush)
    rank = rank_with_ranker(&StraightRanker.rank/1, rank, hand, :straight)
    rank = rank_with_ranker(&ThreeOfAKindRanker.rank/1, rank, hand, :three_of_a_kind)
    rank = rank_with_ranker(&TwoPairRanker.rank/1, rank, hand, :two_pair)
    rank = rank_with_ranker(&SinglePairRanker.rank/1, rank, hand, :single_pair)
    rank = rank_with_ranker(&HighCardRanker.rank/1, rank, hand, :high_card)
    rank
  end

  defp rank_with_ranker(ranker, rank, hand, rank_atom) do
    if rank != nil do
      rank
    else
      rank = if rank == nil, do: ranker.(hand), else: rank
      is_ranked = is_ranked(rank)
      rank = if is_ranked, do: {rank_atom, elem(rank, 1)}, else: nil
      rank
    end
  end

  defp is_ranked(rank) do
    if elem(rank, 0), do: true, else: false
  end
end
