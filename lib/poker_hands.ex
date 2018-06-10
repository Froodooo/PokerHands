defmodule PokerHands do
  alias PokerHands.HandParser, as: HandParser
  alias PokerHands.Rankers.CardRanker, as: CardRanker
  alias PokerHands.Helpers.RankProvider, as: RankProvider
  alias PokerHands.OutputProvider, as: OutputProvider

  @doc ~S"""
  Returns the winner of two poker hands.

  ## Examples
      iex> PokerHands.run("2H 3D 5S 9C KD", "2C 3H 4S 8C AH")
      "White wins - high card: ace"
  """
  def run(black_hand, white_hand) do
    {black_hand_parsed, white_hand_parsed} =
      {HandParser.parse(black_hand), HandParser.parse(white_hand)}

    {black_hand_ranked, white_hand_ranked} =
      {CardRanker.rank(black_hand_parsed), CardRanker.rank(white_hand_parsed)}

    highest_rank = RankProvider.get_highest_rank(black_hand_ranked, white_hand_ranked)

    winner =
      if highest_rank == :tie do
        tied_rank = elem(black_hand_ranked, 0)
        rank_tie_function = RankProvider.get_rank_tie_function(tied_rank)

        rank_tie_function.(
          {black_hand_parsed, elem(black_hand_ranked, 1)},
          {white_hand_parsed, elem(white_hand_ranked, 1)}
        )
      else
        highest_rank
      end

    winner_text = OutputProvider.get_winner_text(winner, black_hand_ranked, white_hand_ranked)
    winner_text
  end
end
