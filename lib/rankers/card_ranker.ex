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
    rank =
      nil
      |> rank(&StraightFlushRanker.rank/1, hand, :straight_flush)
      |> rank(&FourOfAKindRanker.rank/1, hand, :four_of_a_kind)
      |> rank(&FullHouseRanker.rank/1, hand, :full_house)
      |> rank(&FlushRanker.rank/1, hand, :flush)
      |> rank(&StraightRanker.rank/1, hand, :straight)
      |> rank(&ThreeOfAKindRanker.rank/1, hand, :three_of_a_kind)
      |> rank(&TwoPairRanker.rank/1, hand, :two_pair)
      |> rank(&SinglePairRanker.rank/1, hand, :single_pair)
      |> rank(&HighCardRanker.rank/1, hand, :high_card)

    rank
  end

  defp rank(rank, rank_function, hand, rank_atom) do
    rank =
      if rank != nil do
        rank
      else
        rank = rank_function.(hand)
        is_ranked = is_ranked(rank)

        rank =
          if is_ranked,
            do: {rank_atom, elem(rank, 1)},
            else: nil

        rank
      end

    rank
  end

  defp is_ranked(rank) do
    is_ranked =
      if elem(rank, 0),
        do: true,
        else: false

    is_ranked
  end
end
