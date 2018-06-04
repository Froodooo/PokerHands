defmodule PokerHands.Helpers.HandComparer do
  def hands_are_equal(hand_black, hand_white) do
    hand_zipped = Enum.zip(hand_black, hand_white)
    hands_are_equal = Enum.all?(hand_zipped, fn x -> elem(x, 0) == elem(x, 1) end)
    hands_are_equal
  end

  def compare_card_values(hand_black, hand_white) do
    head_black = hd(hand_black)
    head_white = hd(hand_white)

    cond do
      head_black > head_white -> :black
      head_white > head_black -> :white
      true -> compare_card_values(tl(hand_black), tl(hand_white))
    end
  end
end
