defmodule PokerHands.Helpers.SetProvider do
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider

  def get_card_sets(hand, set_size) do
    sets =
      CardValueProvider.get_card_values_indexed(hand)
      |> Enum.group_by(fn x -> elem(x, 0) end)
      |> Map.values()
      |> Enum.filter(fn x -> Enum.count(x) == set_size end)

    sets
  end

  def get_card_sets_indices(sets) do
    highest_card_value = Enum.max(Enum.map(sets, fn x -> elem(hd(x), 0) end))

    sets_indices =
      Enum.filter(sets, fn x -> elem(hd(x), 0) == highest_card_value end)
      |> Enum.flat_map(fn x -> x end)
      |> Enum.map(fn x -> elem(x, 1) end)

    sets_indices
  end
end
