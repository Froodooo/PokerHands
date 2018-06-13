defmodule PokerHands.OutputProvider do
  alias PokerHands.Helpers.TextProvider, as: TextProvider

  @doc ~S"""
  Returns the winning player and its cards as winner text for a given winning player and player hands.

  ## Examples
      iex> PokerHands.OutputProvider.get_output_text({:black, [A: :S]}, :high_card, :high_card)
      "Black wins - high card: ace"
  """
  def get_output_text(winner, black_hand_rank, white_hand_rank) do
    case winner do
      {:black, _} -> create_winner_text(winner, black_hand_rank)
      {:white, _} -> create_winner_text(winner, white_hand_rank)
      {:tie, _} -> "Tie"
    end
  end

  defp get_rank_text(rank) do
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
  end

  defp get_winner_text(winner_player) do
    case winner_player do
      :black -> "Black"
      :white -> "White"
    end
  end

  defp create_winner_text(winner, winner_rank) do
    {winner_player, winner_cards} = winner
    winner_text = get_winner_text(winner_player)
    rank_text = get_rank_text(winner_rank)
    winner_text = "#{winner_text} wins - #{rank_text}"

    rank_winner_card_text =
      if winner_cards == nil,
        do: nil,
        else: TextProvider.get_rank_winner_card_text(winner_rank, winner_cards)

    if rank_winner_card_text == nil,
      do: winner_text,
      else: winner_text <> ": #{rank_winner_card_text}"
  end
end
