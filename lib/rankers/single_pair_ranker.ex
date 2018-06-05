defmodule PokerHands.Rankers.SinglePairRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardValueProvider, as: CardValueProvider
  alias PokerHands.Helpers.SetProvider, as: SetProvider
  alias PokerHands.Rankers.HighCardRanker, as: HighCardRanker
  @behaviour HandRanker

  def rank(hand) do
    sets = SetProvider.get_sets(hand, 2)

    result =
      if Enum.count(sets) == 0 do
        {false, []}
      else
        sets_indices = SetProvider.get_sets_indices(sets)

        Enum.with_index(hand)
        |> CardValueProvider.get_hand_result(sets_indices)
      end

    result
  end

  def tie(hand_black, hand_white) do
    result = CardValueProvider.get_highest_set_value(hand_black, hand_white)

    winner =
      case result do
        :tie -> HighCardRanker.tie(hand_black, hand_white)
        _ -> result
      end

    winner
  end
end
