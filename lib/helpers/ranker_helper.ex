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
    {black_rank_order, white_rank_order} =
      {get_rank_order(black_rank), get_rank_order(white_rank)}

    result =
      cond do
        black_rank_order > white_rank_order -> :black
        white_rank_order > black_rank_order -> :white
        true -> :tie
      end

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

  def get_hand_values(hand_black, hand_white) do
    black_values = Enum.map(hand_black, fn x -> elem(x, 0) end)
    white_values = Enum.map(hand_white, fn x -> elem(x, 0) end)

    black_values_ordered = Enum.sort(black_values, &(&1 >= &2))
    white_values_ordered = Enum.sort(white_values, &(&1 >= &2))

    {black_values_ordered, white_values_ordered}
  end

  def hands_are_equal(hand_black, hand_white) do
    hand_zipped = Enum.zip(hand_black, hand_white)
    hands_are_equal = Enum.all?(hand_zipped, fn x -> elem(x, 0) == elem(x, 1) end)
    hands_are_equal
  end

  def compare_card_values(hand_black, hand_white) do
    head_black = hd(hand_black)
    head_white = hd(hand_white)

    cond do
      head_black > head_white -> :black
      head_white > head_black -> :white
      true -> compare_card_values(tl(hand_black), tl(hand_white))
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
