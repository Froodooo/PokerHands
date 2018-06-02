defmodule PokerHands.ConsoleReader do
  def read(io \\ IO) do
    black_hand = io.gets("Enter black hand:\n")
    white_hand = io.gets("Enter white hand:\n")

    {black_hand, white_hand}
  end
end
