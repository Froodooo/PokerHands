defmodule PokerHands.Helpers.SuitProvider do
  def get_suit(hand, suit_size) do
    suits =
      Enum.group_by(hand, fn x -> elem(x, 1) end)
      |> Map.values()
      |> Enum.filter(fn x -> Enum.count(x) == suit_size end)

    suits
  end
end
