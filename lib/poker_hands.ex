defmodule PokerHands do
  alias PokerHands.ConsoleReader, as: ConsoleReader
  alias PokerHands.HandParser, as: HandParser
  alias PokerHands.Rankers.CardRanker, as: CardRanker
  alias PokerHands.Helpers.RankerHelper, as: RankerHelper

  def run do
    {black_hand, white_hand} = ConsoleReader.read()

    black_hand_parsed = HandParser.parse(black_hand)
    white_hand_parsed = HandParser.parse(white_hand)

    black_hand_rank = CardRanker.rank(black_hand_parsed)
    white_hand_rank = CardRanker.rank(white_hand_parsed)

    highest_rank = RankerHelper.get_highest_rank(black_hand_rank, white_hand_rank)
  end
end
