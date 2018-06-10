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
      "ace of spades"

      iex> PokerHands.Helpers.TextProvider.get_rank_winner_card_text(:straight, [A: :S])
      "ace of spades"

      iex> PokerHands.Helpers.TextProvider.get_rank_winner_card_text(:flush, ["9": :C, T: :C, J: :D, Q: :C, K: :C])
      "king of clubs"

      iex> PokerHands.Helpers.TextProvider.get_rank_winner_card_text(:straight_flush, [T: :C, J: :C, K: :C, Q: :C, A: :C])
      "ace of clubs"
  """
  def get_rank_winner_card_text(rank, winner_cards) do
    rank_winner_card_text =
      case rank do
        :high_card -> get_hand_card_value_text(winner_cards)
        :single_pair -> get_hand_card_value_text(winner_cards)
        :two_pair -> get_two_pair_text(winner_cards)
        :three_of_a_kind -> get_hand_card_value_text(winner_cards)
        :straight -> get_straight_text(winner_cards)
        :flush -> get_straight_text(winner_cards)
        :full_house -> get_full_house_text(winner_cards)
        :four_of_a_kind -> get_hand_card_value_text(winner_cards)
        :straight_flush -> get_straight_text(winner_cards)
      end

    rank_winner_card_text
  end

  defp get_card_suit_text(card_suit) do
    card_suit_text =
      case card_suit do
        :C -> "clubs"
        :D -> "diamonds"
        :H -> "hearts"
        :S -> "spades"
      end

    card_suit_text
  end

  defp get_card_value_text(card_value) do
    card_value_text =
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

    card_value_text
  end

  defp get_hand_card_value_text(winner_cards) do
    text =
      Enum.map(winner_cards, fn x -> elem(x, 0) end)
      |> Enum.map(fn x -> get_card_value_text(x) end)
      |> Enum.join(" and ")

    text
  end

  defp get_full_house_text(winner_cards) do
    text =
      Enum.map(winner_cards, fn x -> elem(x, 1) end)
      |> Enum.uniq()
      |> Enum.map(fn x -> get_card_suit_text(x) end)
      |> Enum.join(" and ")

    text
  end

  defp get_straight_text(winner_cards) do
    highest_card_value =
      CardValueProvider.get_card_values_indexed(winner_cards)
      |> Enum.sort(&(elem(&1, 0) >= elem(&2, 0)))
      |> Enum.at(0)

    highest_card = Enum.at(winner_cards, elem(highest_card_value, 1))

    text =
      "#{get_card_value_text(elem(highest_card, 0))} of #{
        get_card_suit_text(elem(highest_card, 1))
      }"

    text
  end

  defp get_two_pair_text(winner_cards) do
    text =
      Enum.map(winner_cards, fn x -> elem(x, 0) end)
      |> Enum.dedup()
      |> Enum.map(fn x -> get_card_value_text(x) end)
      |> Enum.join(" and ")

    text
  end
end
