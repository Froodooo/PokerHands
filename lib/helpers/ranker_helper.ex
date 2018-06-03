defmodule PokerHands.Helpers.RankerHelper do
  def get_highest_rank(black_rank, white_rank) do
    black_rank_order = get_rank_order(black_rank)
    white_rank_order = get_rank_order(white_rank)

    result = :tie
    result = if black_rank_order > white_rank_order, do: :black, else: result
    result = if white_rank_order > black_rank_order, do: :white, else: result
    result
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
