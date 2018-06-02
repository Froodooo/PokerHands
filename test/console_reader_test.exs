defmodule ConsoleReaderTest do
  alias PokerHands.ConsoleReader, as: ConsoleReader
  use ExUnit.Case

  test "read hands correct size" do
    hand_tuple = ConsoleReader.read(FakeIO)
    assert tuple_size(hand_tuple) == 2
  end

  test "read hands correct contents" do
    hand_tuple = ConsoleReader.read(FakeIO)
    assert hand_tuple == {"2H 3D 5S 9C KD", "2C 3H 4S 8C AH"}
  end
end

defmodule FakeIO do
  def gets("Enter black hand:\n"), do: "2H 3D 5S 9C KD"
  def gets("Enter white hand:\n"), do: "2C 3H 4S 8C AH"
end
