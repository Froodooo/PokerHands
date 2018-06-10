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
      |> Enum.map(fn x -> elem(x, 0) end)
      |> Enum.sort()

    is_increasing_list = is_increasing_list(card_values, hd(card_values), 0)

    rank =
      if is_increasing_list == Enum.count(hand),
        do: {true, hand},
        else: {false, []}

    rank
  end

  def tie(hand_black, hand_white) do
    black_card_values = CardValueProvider.get_card_values(elem(hand_black, 1))
    white_card_values = CardValueProvider.get_card_values(elem(hand_white, 1))

    value_black =
      Enum.sort(black_card_values, &(&1 >= &2))
      |> Enum.at(0)

    value_white =
      Enum.sort(white_card_values, &(&1 >= &2))
      |> Enum.at(0)

    winner =
      cond do
        value_black > value_white -> {:black, nil}
        value_white > value_black -> {:white, nil}
        true -> {:tie, nil}
      end

    winner
  end

  defp is_increasing_list(list, v, n) when tl(list) == [] do
    is_increasing_list =
      if hd(list) == v,
        do: n + 1,
        else: n

    is_increasing_list
  end

  defp is_increasing_list(list, v, n) do
    n =
      if hd(list) == v,
        do: n + 1,
        else: n

    is_increasing_list = is_increasing_list(tl(list), v + 1, n)
    is_increasing_list
  end
end
