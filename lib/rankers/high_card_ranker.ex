defmodule PokerHands.Rankers.HighCardRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.HandComparer, as: HandComparer
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider
  @behaviour HandRanker

  @doc ~S"""
  Ranks the given hand and returns true if it's a high card.

  ## Examples
      iex> PokerHands.Rankers.HighCardRanker.rank([{:"2", :H}, {:"3", :D}, {:"5", :S}, {:"9", :C}, {:K, :D}])
      {true, [{:K, :D}]}
  """
  def rank(hand) do
    highest_card_values =
      CardValueProvider.get_card_values_indexed(hand)
      |> get_highest_card_values()

    result =
      Enum.with_index(hand)
      |> CardValueProvider.get_cards_with_highest_order(highest_card_values)

    result
  end

  def tie(hand_black, hand_white) do
    black_card_values =
      CardValueProvider.get_card_values_indexed(elem(hand_black, 0))
      |> CardValueProvider.get_card_values_sorted()

    white_card_values =
      CardValueProvider.get_card_values_indexed(elem(hand_white, 0))
      |> CardValueProvider.get_card_values_sorted()

    result =
      if HandComparer.hands_are_equal(black_card_values, white_card_values) do
        {:tie, nil}
      else 
        {winner, card_index} = HandComparer.compare_hands_indexed(black_card_values, white_card_values)
        if winner == :tie, do: {:tie, nil}, else: get_tie_winner({winner, card_index}, elem(hand_black, 0), elem(hand_white, 0))
      end

    result
  end

  defp get_tie_winner({winner, card_index}, hand_black, hand_white) do
    result = case winner do
      :black -> [Enum.at(hand_black, card_index)]
      :white -> [Enum.at(hand_white, card_index)]
    end

    {winner, result}
  end

  defp get_highest_card_values(card_values) do
    highest_card_value = Enum.max_by(card_values, fn x -> elem(x, 0) end)

    all_highest_card_values =
      Enum.filter(card_values, fn x -> elem(x, 0) == elem(highest_card_value, 0) end)
      |> Enum.map(fn x -> elem(x, 1) end)

    all_highest_card_values
  end
end
