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

  @doc ~S"""
  Gets the rank for a given hand.

  ## Examples
      iex> PokerHands.Rankers.CardRanker.rank(["2": :C,"3": :C,"5": :C,"9": :D,K: :H])
      {:high_card, [K: :H]}

      iex> PokerHands.Rankers.CardRanker.rank(["2": :C,"3": :C,"5": :C,K: :D,K: :H])
      {:single_pair, [K: :D, K: :H]}

      iex> PokerHands.Rankers.CardRanker.rank(["2": :C,"3": :C,"2": :S,K: :D,K: :H])
      {:two_pair, ["2": :C,"2": :S,K: :D,K: :H]}

      iex> PokerHands.Rankers.CardRanker.rank(["2": :C,K: :C,"3": :S,K: :D,K: :H])
      {:three_of_a_kind, [K: :C,K: :D,K: :H]}

      iex> PokerHands.Rankers.CardRanker.rank([T: :C,J: :C,Q: :S,K: :D,A: :H])
      {:straight, [T: :C,J: :C,Q: :S,K: :D,A: :H]}

      iex> PokerHands.Rankers.CardRanker.rank(["9": :C,J: :C,Q: :C,K: :C,A: :C])
      {:flush, ["9": :C,J: :C,Q: :C,K: :C,A: :C]}

      iex> PokerHands.Rankers.CardRanker.rank(["9": :C,J: :C,Q: :C,K: :D,A: :D])
      {:full_house, ["9": :C,J: :C,Q: :C,K: :D,A: :D]}

      iex> PokerHands.Rankers.CardRanker.rank(["9": :C,"9": :D,"9": :S,"9": :H,A: :D])
      {:four_of_a_kind, ["9": :C,"9": :D,"9": :S,"9": :H]}

      iex> PokerHands.Rankers.CardRanker.rank(["2": :C,"3": :C,"5": :C,"9": :C,K: :C])
      {:flush, ["2": :C,"3": :C,"5": :C,"9": :C,K: :C]}

      iex> PokerHands.Rankers.CardRanker.rank([T: :C,J: :C,Q: :C,K: :C,A: :C])
      {:straight_flush, [T: :C,J: :C,Q: :C,K: :C,A: :C]}
  """
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
    ranked_hand =
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

    ranked_hand
  end

  defp is_ranked(rank) do
    is_ranked =
      if elem(rank, 0),
        do: true,
        else: false

    is_ranked
  end
end
