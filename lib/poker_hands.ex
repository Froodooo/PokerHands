defmodule PokerHands do
  alias PokerHands.ConsoleReader, as: ConsoleReader
  alias PokerHands.HandParser, as: HandParser

  def run do
    {black_hand, white_hand} = ConsoleReader.read()

    black_hand_parsed = HandParser.parse(black_hand)
    white_hand_parsed = HandParser.parse(white_hand)

    {black_hand_parsed, white_hand_parsed}
  end
end
