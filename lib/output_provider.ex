defmodule PokerHands.OutputProvider do
  alias PokerHands.Helpers.TextProvider, as: TextProvider

  @doc ~S"""
  Returns the winning player and its cards as winner text for a given winning player and player hands.

  ## Examples
      iex> PokerHands.OutputProvider.get_winner_text({:black, nil}, {:high_card, [{:A, :D}]}, {:high_card, [{:K, :D}]})
      "Black wins - high card"
  """
  def get_winner_text(winner, hand_black, hand_white) do
    winner_text =
      case winner do
        {:black, _} -> create_winner_text(winner, hand_black)
        {:white, _} -> create_winner_text(winner, hand_white)
        {:tie, _} -> "Tie"
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

  defp get_winner_text(winner) do
    winner_text =
      case winner do
        {:black, _} -> "Black"
        {:white, _} -> "White"
      end

    winner_text
  end

  defp create_winner_text(winner, hand) do
    winner_text = get_winner_text(winner)
    rank = elem(hand, 0)
    rank_text = get_rank_text(rank)
    winner_cards = elem(winner, 1)
    winner_text = "#{winner_text} wins - #{rank_text}"

    rank_winner_card_text =
      if winner_cards == nil,
        do: nil,
        else: TextProvider.get_rank_winner_card_text(rank, winner_cards)

    winner_text =
      if rank_winner_card_text == nil,
        do: winner_text,
        else: winner_text <> ": #{rank_winner_card_text}"

    winner_text
  end
end
