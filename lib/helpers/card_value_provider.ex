defmodule PokerHands.Helpers.CardValueProvider do
  def get_card_values(hand) do
    card_values = Enum.map(hand, fn x -> get_card_value_order(elem(x, 0)) end)
    card_values
  end

  def get_card_values_indexed(hand) do
    card_values = get_card_values(hand) |> Enum.with_index()
    card_values
  end

  def get_card_values(hand_black, hand_white) do
    {hand_black_compare, hand_white_compare} = {elem(hand_black, 0), elem(hand_white, 0)}

    {black_card_values, white_card_values} =
      {get_card_values_indexed(hand_black_compare), get_card_values_indexed(hand_white_compare)}

    {black_card_values, white_card_values}
  end

  def get_hand_values(hand_black, hand_white) do
    black_values = Enum.map(hand_black, fn x -> elem(x, 0) end)
    white_values = Enum.map(hand_white, fn x -> elem(x, 0) end)

    black_values_ordered = Enum.sort(black_values, &(&1 >= &2))
    white_values_ordered = Enum.sort(white_values, &(&1 >= &2))

    {black_values_ordered, white_values_ordered}
  end

  def get_hand_result(hand_with_index, all_highest_orders_indices) do
    hand_result =
      Enum.filter(hand_with_index, fn x -> elem(x, 1) in all_highest_orders_indices end)
      |> Enum.map(fn x -> elem(x, 0) end)

    result = {true, hand_result}
    result
  end

  defp get_card_value_order(atom) do
    case atom do
      :"1" -> 1
      :"2" -> 2
      :"3" -> 3
      :"4" -> 4
      :"5" -> 5
      :"6" -> 6
      :"7" -> 7
      :"8" -> 8
      :"9" -> 9
      :T -> 10
      :J -> 11
      :Q -> 12
      :K -> 13
      :A -> 14
    end
  end
end
