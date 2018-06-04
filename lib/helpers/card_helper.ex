defmodule PokerHands.Helpers.CardHelper do
  def get_card_values(hand) do
    card_values = Enum.map(hand, fn x -> get_card_value_order(elem(x, 0)) end)
    card_values
  end

  def get_card_values_indexed(hand) do
    card_values = get_card_values(hand)
    card_values_indexed = Enum.with_index(card_values)
    card_values_indexed
  end

  def get_hand_result(hand_with_index, all_highest_orders_indices) do
    hand_result_with_index =
      Enum.filter(hand_with_index, fn x -> elem(x, 1) in all_highest_orders_indices end)

    hand_result = Enum.map(hand_result_with_index, fn x -> elem(x, 0) end)
    result = {true, hand_result}
    result
  end

  def get_sets(hand, set_size) do
    sets =
      get_card_values_indexed(hand)
      |> Enum.group_by(fn x -> elem(x, 0) end)
      |> Map.values()
      |> Enum.filter(fn x -> Enum.count(x) == set_size end)

    sets
  end

  def get_suit(hand, suit_size) do
    suits_grouped = Enum.group_by(hand, fn x -> elem(x, 1) end)
    suits_values = Map.values(suits_grouped)
    suits = Enum.filter(suits_values, fn x -> Enum.count(x) == suit_size end)
    suits
  end

  def get_sets_indices(sets) do
    highest_card_value = Enum.max(Enum.map(sets, fn x -> elem(hd(x), 0) end))

    sets_indices =
      Enum.filter(sets, fn x -> elem(hd(x), 0) == highest_card_value end)
      |> Enum.flat_map(fn x -> x end)
      |> Enum.map(fn x -> elem(x, 1) end)

    sets_indices
  end

  def get_card_values(hand_black, hand_white) do
    {hand_black_compare, hand_white_compare} = {elem(hand_black, 0), elem(hand_white, 0)}

    {black_card_values, white_card_values} =
      {get_card_values_indexed(hand_black_compare), get_card_values_indexed(hand_white_compare)}

    {black_card_values, white_card_values}
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
