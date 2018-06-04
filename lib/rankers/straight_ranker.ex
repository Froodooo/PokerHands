defmodule PokerHands.Rankers.StraightRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  @behaviour HandRanker

  def rank(hand) do
    card_values =
      CardHelper.get_card_values_indexed(hand) |> Enum.map(fn x -> elem(x, 0) end) |> Enum.sort()

    is_increasing_list = is_increasing_list(card_values, hd(card_values), 0)

    rank =
      if is_increasing_list == Enum.count(hand),
        do: {true, hand},
        else: {false, []}

    rank
  end

  def tie(hand_black, hand_white) do
    {hand_black_straight, hand_white_straight} = {elem(hand_black, 1), elem(hand_white, 1)}

    {black_card_values, white_card_values} =
      {CardHelper.get_card_values(hand_black_straight),
       CardHelper.get_card_values(hand_white_straight)}

    {black_card_values_sorted, white_card_values_sorted} =
      {Enum.sort(black_card_values, &(&1 >= &2)), Enum.sort(white_card_values, &(&1 >= &2))}

    {value_black, value_white} =
      {Enum.at(black_card_values_sorted, 0), Enum.at(white_card_values_sorted, 0)}

    winner =
      cond do
        value_black > value_white -> :black
        value_white > value_black -> :white
        true -> :tie
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
