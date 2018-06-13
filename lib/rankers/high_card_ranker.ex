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

    Enum.with_index(hand)
    |> CardValueProvider.get_cards_with_highest_order(highest_card_values)
  end

  @doc ~S"""
  Ranks the tied high card hands and returns the winner (if any).

  ## Examples
      iex> PokerHands.Rankers.HighCardRanker.tie(
      ...> {["2": :H, "3": :D, "5": :S, "9": :C, K: :D], [K: :D]},
      ...> {["2": :C, "3": :H, "4": :S, "8": :C, A: :H], [A: :H]})
      {:white, [A: :H]}
  """
  def tie(hand_black, hand_white) do
    {black_hand_parsed, _} = hand_black
    {white_hand_parsed, _} = hand_white

    black_card_values =
      CardValueProvider.get_card_values_indexed(black_hand_parsed)
      |> CardValueProvider.get_card_values_sorted()

    white_card_values =
      CardValueProvider.get_card_values_indexed(white_hand_parsed)
      |> CardValueProvider.get_card_values_sorted()

    if HandComparer.hands_are_equal(black_card_values, white_card_values) do
      {:tie, nil}
    else
      {winner, card_index} =
        HandComparer.compare_hands_indexed(black_card_values, white_card_values)

      if winner == :tie,
        do: {:tie, nil},
        else: get_tie_winner({winner, card_index}, black_hand_parsed, white_hand_parsed)
    end
  end

  defp get_tie_winner({winner, card_index}, hand_black, hand_white) do
    result =
      case winner do
        :black -> [Enum.at(hand_black, card_index)]
        :white -> [Enum.at(hand_white, card_index)]
      end

    {winner, result}
  end

  defp get_highest_card_values(card_values) do
    {highest_card_value, _} = Enum.max_by(card_values, fn {x, _} -> x end)

    Enum.filter(card_values, fn {x, _} -> x == highest_card_value end)
    |> Enum.map(fn {_, x} -> x end)
  end
end
