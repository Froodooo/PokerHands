defmodule PokerHands.Helpers.SetProvider do
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider

  @doc ~S"""
  Gets card sets for a given hand and set size.

  ## Examples
      iex> PokerHands.Helpers.SetProvider.get_card_sets(["2": :H,"3": :H,"2": :H,"3": :C,K: :D], 2)
      [[{2, 0}, {2, 2}], [{3, 1}, {3, 3}]]

      iex> PokerHands.Helpers.SetProvider.get_card_sets(["2": :H,"3": :H,"5": :H,"6": :H,"2": :C], 2)
      [[{2, 0}, {2, 4}]]

      iex> PokerHands.Helpers.SetProvider.get_card_sets(["2": :H,"3": :H,"5": :H,"6": :H,"K": :C], 2)
      []
  """
  def get_card_sets(hand, set_size) do
    sets =
      CardValueProvider.get_card_values_indexed(hand)
      |> Enum.group_by(fn x -> elem(x, 0) end)
      |> Map.values()
      |> Enum.filter(fn x -> Enum.count(x) == set_size end)

    sets
  end

  @doc ~S"""
  Gets card indicies for given sets.

  ## Examples
      iex> PokerHands.Helpers.SetProvider.get_card_sets_indices([[{2, 0}, {2, 2}], [{3, 1}, {3, 3}]])
      [1, 3]

      iex> PokerHands.Helpers.SetProvider.get_card_sets_indices([[{2, 0}, {2, 4}]])
      [0, 4]
  """
  def get_card_sets_indices(sets) do
    highest_card_value = Enum.max(Enum.map(sets, fn x -> elem(hd(x), 0) end))

    sets_indices =
      Enum.filter(sets, fn x -> elem(hd(x), 0) == highest_card_value end)
      |> Enum.flat_map(fn x -> x end)
      |> Enum.map(fn x -> elem(x, 1) end)

    sets_indices
  end
end
