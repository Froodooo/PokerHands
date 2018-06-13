defmodule PokerHands.Helpers.TextProvider do
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider

  @doc ~S"""
  Gets the text to be printed for the winning hand.

  ## Examples
      iex> PokerHands.Helpers.TextProvider.get_rank_winner_card_text(:high_card, [K: :C])
      "king"

      iex> PokerHands.Helpers.TextProvider.get_rank_winner_card_text(:two_pair, [K: :C])
      "king"

      iex> PokerHands.Helpers.TextProvider.get_rank_winner_card_text(:two_pair, [K: :C, K: :D, A: :C, A: :D])
      "king and ace"

      iex> PokerHands.Helpers.TextProvider.get_rank_winner_card_text(:straight, [T: :C, J: :D, Q: :C, K: :D, A: :S])
      "ace"

      iex> PokerHands.Helpers.TextProvider.get_rank_winner_card_text(:straight, [A: :S])
      "ace"

      iex> PokerHands.Helpers.TextProvider.get_rank_winner_card_text(:flush, ["9": :C, T: :C, J: :D, Q: :C, K: :C])
      "king"

      iex> PokerHands.Helpers.TextProvider.get_rank_winner_card_text(:straight_flush, [T: :C, J: :C, K: :C, Q: :C, A: :C])
      "ace"
  """
  def get_rank_winner_card_text(rank, winner_cards) do
    case rank do
      :high_card -> get_hand_card_value_text(winner_cards)
      :single_pair -> get_unique_card_values_text(winner_cards)
      :two_pair -> get_two_pair_text(winner_cards)
      :three_of_a_kind -> get_unique_card_values_text(winner_cards)
      :straight -> get_highest_card_value_text(winner_cards)
      :flush -> get_highest_card_value_text(winner_cards)
      :full_house -> get_highest_card_value_text(winner_cards)
      :four_of_a_kind -> get_unique_card_values_text(winner_cards)
      :straight_flush -> get_highest_card_value_text(winner_cards)
    end
  end

  defp get_card_value_text(card_value) do
    case card_value do
      :"2" -> "two"
      :"3" -> "three"
      :"4" -> "four"
      :"5" -> "five"
      :"6" -> "six"
      :"7" -> "seven"
      :"8" -> "eight"
      :"9" -> "nine"
      :T -> "ten"
      :J -> "jack"
      :Q -> "queen"
      :K -> "king"
      :A -> "ace"
    end
  end

  defp get_hand_card_value_text(winner_cards) do
    Enum.map(winner_cards, fn {x, _} ->
      "#{get_card_value_text(x)}"
    end)
    |> Enum.join(" and ")
  end

  defp get_highest_card_value_text(winner_cards) do
    {_, highest_card_index} =
      CardValueProvider.get_card_values_indexed(winner_cards)
      |> Enum.sort(&(elem(&1, 0) >= elem(&2, 0)))
      |> Enum.at(0)

    {highest_card, _} = Enum.at(winner_cards, highest_card_index)

    "#{get_card_value_text(highest_card)}"
  end

  defp get_two_pair_text(winner_cards) do
    Enum.map(winner_cards, fn {x, _} -> x end)
    |> Enum.dedup()
    |> Enum.map(fn x -> get_card_value_text(x) end)
    |> Enum.join(" and ")
  end

  defp get_unique_card_values_text(winner_cards) do
    Enum.map(winner_cards, fn {x, _} -> x end)
    |> Enum.uniq()
    |> Enum.map(fn x -> get_card_value_text(x) end)
    |> Enum.join(" and ")
  end
end
