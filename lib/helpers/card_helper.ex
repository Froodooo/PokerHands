defmodule PokerHands.Helpers.CardHelper do
  def get_hand_order_indexed(hand) do
    hand_order = Enum.map(hand, fn x -> get_card_value_order(elem(x, 0)) end)
    hand_order_indexed = Enum.with_index(hand_order)
    hand_order_indexed
  end

  def get_hand_result(hand_with_index, all_highest_orders_indices) do
    hand_result_with_index =
      Enum.filter(hand_with_index, fn x -> elem(x, 1) in all_highest_orders_indices end)

    hand_result = Enum.map(hand_result_with_index, fn x -> elem(x, 0) end)
    result = {true, hand_result}
    result
  end

  def get_sets(hand, set_size) do
    hand_order_indexed = get_hand_order_indexed(hand)
    hand_order_grouped = Enum.group_by(hand_order_indexed, fn x -> elem(x, 0) end)
    hand_order_grouped_values = Map.values(hand_order_grouped)
    pairs = Enum.filter(hand_order_grouped_values, fn x -> Enum.count(x) == set_size end)
    pairs
  end

  def get_suit(hand, suit_size) do
    suits_grouped = Enum.group_by(hand, fn x -> elem(x, 1) end)
    suits_values = Map.values(suits_grouped)
    suits = Enum.filter(suits_values, fn x -> Enum.count(x) == suit_size end)
    suits
  end

  def get_sets_indices(sets) do
    highest_pair_value = Enum.max(Enum.map(sets, fn x -> elem(hd(x), 0) end))
    sets_list = Enum.filter(sets, fn x -> elem(hd(x), 0) == highest_pair_value end)
    sets_flat = Enum.flat_map(sets_list, fn x -> x end)
    sets_indices = Enum.map(sets_flat, fn x -> elem(x, 1) end)
    sets_indices
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
