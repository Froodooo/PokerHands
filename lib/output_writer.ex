defmodule PokerHands.OutputWriter do
  def write_winner(highest_rank, hand_black, hand_white) do
    case highest_rank do
      :black -> write_to_console(highest_rank, elem(hand_black, 0))
      :white -> write_to_console(highest_rank, elem(hand_white, 0))
      :tie -> IO.puts(highest_rank)
    end
  end

  defp write_to_console(winner, rank) do
    winner_text = get_winner_text(winner)
    rank_text = get_rank_text(rank)
    IO.puts("#{winner_text} wins - #{rank_text}")
  end

  defp get_winner_text(winner) do
    winner_text =
      case winner do
        :black -> "Black"
        :white -> "White"
      end

    winner_text
  end

  defp get_rank_text(rank) do
    rank_text =
      case rank do
        :high_card -> "high card"
        :single_pair -> "single pair"
        :two_pair -> "two pair"
        :three_of_a_kind -> "three of a kind"
        :straight -> "straight"
        :flush -> "flush"
        :full_house -> "full house"
        :four_of_a_kind -> "four of a kind"
        :straight_flush -> "straight flush"
      end

    rank_text
  end
end
