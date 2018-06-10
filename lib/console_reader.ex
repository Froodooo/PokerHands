defmodule PokerHands.ConsoleReader do

  @doc ~S"""
  Reads a given hand from the console.

  ## Examples
      iex> alias PokerHands.FakeIOReader, as: FakeIO
      ...> PokerHands.ConsoleReader.read(FakeIO)
      {"2H 3D 5S 9C KD", "2C 3H 4S 8C AH"}
  """
  def read(io) do
    black_hand = io.gets("Enter black hand:\n")
    white_hand = io.gets("Enter white hand:\n")

    {black_hand, white_hand}
  end
end
