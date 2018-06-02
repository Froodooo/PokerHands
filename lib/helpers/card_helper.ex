defmodule PokerHands.Helpers.CardHelper do

  def get_card_value_order(atom) do
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

  def get_hand_order_indexed(hand) do
    hand_order = Enum.map(hand, fn(x) -> get_card_value_order(elem(x, 0)) end)
    hand_order_indexed = Enum.with_index(hand_order)
    hand_order_indexed
  end

  def get_hand_result(hand_with_index, all_highest_orders_indices) do
    hand_result_with_index = Enum.filter(hand_with_index, fn(x) -> elem(x, 1) in all_highest_orders_indices end)
    hand_result = Enum.map(hand_result_with_index, fn(x) -> elem(x, 0) end)
    result = {true, hand_result}
    result
  end

end