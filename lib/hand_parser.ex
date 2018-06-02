defmodule PokerHands.HandParser do
  def parse(hand) do
    split_hand = String.split(hand)
    parsed_hand = Enum.map(split_hand, fn x -> {String.at(x, 0), String.at(x, 1)} end)

    parsed_hand_atoms =
      Enum.map(parsed_hand, fn {v, s} -> {String.to_atom(v), String.to_atom(s)} end)

    parsed_hand_atoms
  end
end
