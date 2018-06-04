defmodule PokerHands.HandParser do
  def parse(hand) do
    parsed_hand =
      String.split(hand)
      |> Enum.map(fn x -> {String.at(x, 0), String.at(x, 1)} end)
      |> Enum.map(fn {v, s} -> {String.to_atom(v), String.to_atom(s)} end)

    parsed_hand
  end
end
