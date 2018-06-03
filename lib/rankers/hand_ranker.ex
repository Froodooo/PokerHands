defmodule PokerHands.Rankers.HandRanker do
  @type hand :: [{atom, atom}]

  @callback rank(hand) :: {boolean, hand}
end
