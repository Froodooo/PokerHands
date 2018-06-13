defmodule PokerHands.Helpers.SuitProvider do
  @doc ~S"""
  Gets suits for a given hand and a suit size.

  ## Examples
      iex> PokerHands.Helpers.SuitProvider.get_suit(["2": :C,"3": :C,"5": :C,"9": :C,K: :C], 5)
      [["2": :C,"3": :C,"5": :C,"9": :C,K: :C]]

      iex> PokerHands.Helpers.SuitProvider.get_suit(["2": :C,"3": :C,"5": :C,"9": :D,K: :D], 3)
      [["2": :C,"3": :C,"5": :C]]

      iex> PokerHands.Helpers.SuitProvider.get_suit(["2": :C,"3": :C,"5": :C,"9": :D,K: :D], 2)
      [["9": :D,K: :D]]
  """
  def get_suit(hand, suit_size) do
    Enum.group_by(hand, fn {_, x} -> x end)
    |> Map.values()
    |> Enum.filter(fn x -> Enum.count(x) == suit_size end)
  end
end
