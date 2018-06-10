defmodule PokerHands.HandParser do
  
  @doc ~S"""
  Parses the given hand into a format that the program recognizes.

  ## Examples
      iex> PokerHands.HandParser.parse("2H 3D 5S 9C KD")
      [{:"2", :H},{:"3", :D},{:"5", :S},{:"9", :C},{:K, :D}]
  """
  def parse(hand) do
    parsed_hand =
      String.split(hand)
      |> Enum.map(fn x -> {String.at(x, 0), String.at(x, 1)} end)
      |> Enum.map(fn {v, s} -> {String.to_atom(v), String.to_atom(s)} end)

    parsed_hand
  end
end
