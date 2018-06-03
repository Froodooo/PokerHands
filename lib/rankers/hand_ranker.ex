defmodule PokerHands.Rankers.HandRanker do
  @type hand :: [{atom, atom}]
  @type ranked_hand :: {hand, hand}

  @callback rank(hand) :: {boolean, hand}
  @callback tie(ranked_hand, ranked_hand) :: atom
end
