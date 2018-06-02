defmodule PokerHands.Rankers.StraightFlushRanker do
  alias PokerHands.Rankers.HandRanker, as: HandRanker
  #alias PokerHands.Helpers.CardHelper, as: CardHelper
  @behaviour HandRanker
  
  def rank(hand) do
    {true, hand}
  end

end