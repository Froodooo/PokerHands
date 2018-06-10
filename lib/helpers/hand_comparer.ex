defmodule PokerHands.Helpers.HandComparer do
  @doc ~S"""
  Determines if two hands of numerical indexed card values are equal.

  ## Examples
      iex> PokerHands.Helpers.HandComparer.hands_are_equal(
      ...> [{2,0},{3,1},{5,2},{9,3},{13,4}],
      ...> [{2,0},{3,1},{5,2},{9,3},{13,4}])
      true

      iex> PokerHands.Helpers.HandComparer.hands_are_equal(
      ...> [{2,0},{3,1},{5,2},{9,3},{13,4}],
      ...> [{2,0},{3,1},{4,2},{8,3},{14,4}])
      false
  """
  def hands_are_equal(hand_black, hand_white) do
    hand_zipped = Enum.zip(hand_black, hand_white)
    hands_are_equal = Enum.all?(hand_zipped, fn x -> elem(x, 0) == elem(x, 1) end)
    hands_are_equal
  end

  @doc ~S"""
  Determines who wins given two lists of numerical indexed card values.

  ## Examples
      iex> PokerHands.Helpers.HandComparer.compare_hands([13,9,5,3,2],[14,8,4,3,2])
      :white

      iex> PokerHands.Helpers.HandComparer.compare_hands([14,8,4,3,2],[13,9,5,3,2])
      :black
  """
  def compare_hands(hand_black, hand_white) do
    head_black = hd(hand_black)
    head_white = hd(hand_white)

    winner =
      cond do
        head_black > head_white -> :black
        head_white > head_black -> :white
        true -> compare_hands(tl(hand_black), tl(hand_white))
      end

    winner
  end
end
