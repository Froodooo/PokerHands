defmodule PokerHands.Rankers.StraightRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider
  @behaviour HandRanker

  @doc ~S"""
  Ranks the given hand and returns true if it's a straight.

  ## Examples
      iex> PokerHands.Rankers.StraightRanker.rank([{:"3", :S}, {:"2", :S}, {:"5", :S}, {:"6", :C}, {:"4", :C}])
      {true, [{:"3", :S}, {:"2", :S}, {:"5", :S}, {:"6", :C}, {:"4", :C}]}
  """
  def rank(hand) do
    card_values =
      CardValueProvider.get_card_values_indexed(hand)
      |> Enum.map(fn {x, _} -> x end)
      |> Enum.sort()

    is_increasing_list = is_increasing_list(card_values, hd(card_values), 0)

    if is_increasing_list == Enum.count(hand),
      do: {true, hand},
      else: {false, []}
  end

  @doc ~S"""
  Ranks the tied straight hands and returns the winner (if any).

  ## Examples
      iex> PokerHands.Rankers.StraightRanker.tie(
      ...> {["9": :H, K: :C, J: :S, T: :C, Q: :D], ["9": :H, K: :C, J: :S, T: :C, Q: :D]},
      ...> {["8": :C, T: :H, Q: :S, J: :D, "9": :S], ["8": :C, T: :H, Q: :S, J: :D, "9": :S]})
      {:black, [K: :C]}
  """
  def tie(hand_black, hand_white) do
    {_, black_hand_ranked} = hand_black
    {_, white_hand_ranked} = hand_white
    black_card_values = CardValueProvider.get_card_values_indexed(black_hand_ranked)
    white_card_values = CardValueProvider.get_card_values_indexed(white_hand_ranked)

    {value_black, index_black} =
      Enum.sort(black_card_values, &(elem(&1, 0) >= elem(&2, 0)))
      |> Enum.at(0)

    {value_white, index_white} =
      Enum.sort(white_card_values, &(elem(&1, 0) >= elem(&2, 0)))
      |> Enum.at(0)

    cond do
      value_black > value_white -> {:black, [Enum.at(black_hand_ranked, index_black)]}
      value_white > value_black -> {:white, [Enum.at(white_hand_ranked, index_white)]}
      true -> {:tie, nil}
    end
  end

  defp is_increasing_list(list, value, counter) when tl(list) == [] do
    if hd(list) == value,
      do: counter + 1,
      else: counter
  end

  defp is_increasing_list(list, value, counter) do
    counter =
      if hd(list) == value,
        do: counter + 1,
        else: counter

    is_increasing_list(tl(list), value + 1, counter)
  end
end
