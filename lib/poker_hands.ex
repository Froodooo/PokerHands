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

      iex> PokerHands.run("2H 4S 4C 3D 4H", "2S 8S AS QS 3S")
      "White wins - flush: ace"

      iex> PokerHands.run("2H 3D 5S 9C KD", "2C 3H 4S 8C KH")
      "Black wins - high card: nine"

      iex> PokerHands.run("2H 3D 5S 9C KD", "2D 3H 5C 9S KH")
      "Tie"
  """
  def run(black_hand, white_hand) do
    black_hand_parsed = HandParser.parse(black_hand)
    white_hand_parsed = HandParser.parse(white_hand)

    {black_hand_rank, black_hand_ranked_cards} = CardRanker.rank(black_hand_parsed)
    {white_hand_rank, white_hand_ranked_cards} = CardRanker.rank(white_hand_parsed)

    winner_player =
      RankProvider.get_winner_player(
        {black_hand_rank, black_hand_ranked_cards},
        {white_hand_rank, white_hand_ranked_cards}
      )

    {winner_player, winner_cards} =
      case winner_player do
        :tie ->
          determine_winner_by_tie(
            black_hand_parsed,
            {black_hand_rank, black_hand_ranked_cards},
            white_hand_parsed,
            {white_hand_rank, white_hand_ranked_cards}
          )

        _ ->
          determine_winner_by_highest_rank(
            winner_player,
            black_hand_ranked_cards,
            white_hand_ranked_cards
          )
      end

    OutputProvider.get_output_text(
      {winner_player, winner_cards},
      black_hand_rank,
      white_hand_rank
    )
  end

  defp determine_winner_by_highest_rank(winner_player, black_hand_ranked, white_hand_ranked) do
    winner_cards =
      case winner_player do
        :black -> black_hand_ranked
        :white -> white_hand_ranked
      end

    {winner_player, winner_cards}
  end

  defp determine_winner_by_tie(
         black_hand_parsed,
         black_hand_ranked,
         white_hand_parsed,
         white_hand_ranked
       ) do
    {black_hand_rank, black_hand_ranked_cards} = black_hand_ranked
    {_, white_hand_ranked_cards} = white_hand_ranked
    rank_tie_function = RankProvider.get_rank_tie_function(black_hand_rank)

    rank_tie_function.(
      {black_hand_parsed, black_hand_ranked_cards},
      {white_hand_parsed, white_hand_ranked_cards}
    )
  end
end
