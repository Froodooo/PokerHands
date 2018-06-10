defmodule PokerHands.OutputWriter do
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider

  @doc ~S"""
  Return the winning player and its cards for a given winning player and player hands.

  ## Examples
      iex> alias PokerHands.FakeIOWriter, as: FakeIOWriter
      ...> PokerHands.OutputWriter.write_winner(FakeIOWriter, :black, {:high_card, [{:A, :D}]}, {:high_card, [{:K, :D}]})
      :ok
  """
  def write_winner(io \\ IO, highest_rank, hand_black, hand_white) do
    case highest_rank do
      :black -> write_to_console(io, highest_rank, hand_black)
      :white -> write_to_console(io, highest_rank, hand_white)
      :tie -> IO.puts(highest_rank)
    end
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

  defp get_flush_text(hand) do
    {_, card_suit} = Enum.at(hand, 0)
    card_suit_text = get_card_suit_text(card_suit)
    text = "#{card_suit_text}"
    text
  end

  def get_full_house_text(hand) do
    text =
      Enum.map(hand, fn x -> elem(x, 1) end)
      |> Enum.uniq()
      |> Enum.map(fn x -> get_card_suit_text(x) end)
      |> Enum.join(" and ")

    text
  end

  defp get_hand_card_value_text(hand) do
    {card_value, _} = Enum.at(hand, 0)
    card_value_text = get_card_value_text(card_value)
    text = "#{card_value_text}"
    text
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

  defp get_rank_winner_card_text(rank, hand) do
    rank_winner_card_text =
      case rank do
        :high_card -> get_hand_card_value_text(hand)
        :single_pair -> get_hand_card_value_text(hand)
        :two_pair -> get_two_pair_text(hand)
        :three_of_a_kind -> get_hand_card_value_text(hand)
        :straight -> get_straight_text(hand)
        :flush -> get_flush_text(hand)
        :full_house -> get_full_house_text(hand)
        :four_of_a_kind -> get_hand_card_value_text(hand)
        :straight_flush -> get_straight_flush_text()
      end

    rank_winner_card_text
  end

  defp get_straight_flush_text do
    text = "ace"
    text
  end

  defp get_straight_text(hand) do
    highest_card_value =
      CardValueProvider.get_card_values_indexed(hand)
      |> Enum.sort(&(elem(&1, 0) >= elem(&2, 0)))
      |> Enum.at(0)

    highest_card = Enum.at(hand, elem(highest_card_value, 1))

    text =
      "#{get_card_value_text(elem(highest_card, 0))} of #{
        get_card_suit_text(elem(highest_card, 1))
      }"

    text
  end

  defp get_two_pair_text(hand) do
    text =
      Enum.map(hand, fn x -> elem(x, 0) end)
      |> Enum.dedup()
      |> Enum.map(fn x -> get_card_value_text(x) end)
      |> Enum.join(" and ")

    text
  end

  defp get_winner_text(winner) do
    winner_text =
      case winner do
        :black -> "Black"
        :white -> "White"
      end

    winner_text
  end

  defp write_to_console(io, winner, hand) do
    winner_text = get_winner_text(winner)
    rank = elem(hand, 0)
    rank_text = get_rank_text(rank)
    rank_hand = elem(hand, 1)
    rank_winner_card_text = get_rank_winner_card_text(rank, rank_hand)
    io.puts("#{winner_text} wins - #{rank_text}: #{rank_winner_card_text}")
  end
end
