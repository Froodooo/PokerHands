defmodule PokerHands.FakeIOReader do
  def gets("Enter black hand:\n"), do: "2H 3D 5S 9C KD"
  def gets("Enter white hand:\n"), do: "2C 3H 4S 8C AH"
end