defmodule PokerHands.Rankers.FlushRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  alias PokerHands.Helpers.CardHelper, as: CardHelper
  @behaviour HandRanker
  
  def rank(hand) do
    suits = CardHelper.get_suit(hand, 5)
    if (Enum.count(suits) == 0), do: {false, []}, else: {true, hand}
  end

end