defmodule PokerHands do
  alias PokerHands.ConsoleReader, as: ConsoleReader
  alias PokerHands.HandParser, as: HandParser
  alias PokerHands.Rankers.CardRanker, as: CardRanker
  alias PokerHands.Helpers.RankProvider, as: RankProvider
  alias PokerHands.OutputWriter, as: OutputWriter

  def run(io \\IO) do
    {black_hand, white_hand} = ConsoleReader.read(io)

    {black_hand_parsed, white_hand_parsed} =
      {HandParser.parse(black_hand), HandParser.parse(white_hand)}

    {black_hand_rank, white_hand_rank} =
      {CardRanker.rank(black_hand_parsed), CardRanker.rank(white_hand_parsed)}

    highest_rank = RankProvider.get_highest_rank(black_hand_rank, white_hand_rank)

    winner =
      if highest_rank == :tie do
        tied_rank = elem(black_hand_rank, 0)
        rank_tie_function = RankProvider.get_rank_tie_function(tied_rank)

        rank_tie_function.(
          {black_hand_parsed, elem(black_hand_rank, 1)},
          {white_hand_parsed, elem(white_hand_rank, 1)}
        )
      else
        highest_rank
      end

    OutputWriter.write_winner(winner, black_hand_rank, white_hand_rank)
  end
end
