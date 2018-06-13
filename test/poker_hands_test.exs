defmodule PokerHandsTest do
  use ExUnit.Case
  doctest PokerHands

  test "high card tie" do
    assert PokerHands.run("2D 3H 7C 8S JD", "2H 3C 7S 8D JD") == "Tie"
  end

  test "high card win over high card" do
    assert PokerHands.run("2D 3H 7C 8S JD", "2H 3C 7S 8D KD") == "White wins - high card: king"
  end

  test "high card win over high card by high card" do
    assert PokerHands.run("2D 3H 7C 8S JD", "2H 4C 7S 8D JS") == "White wins - high card: four"
  end

  test "single pair tie" do
    assert PokerHands.run("2D 3H 7C JS JD", "2H 3C 7S JC JH") == "Tie"
  end

  test "single pair win over single pair" do
    assert PokerHands.run("2D 3H 7C JS JD", "2H 3C 7S QC QH") == "White wins - single pair: queen"
  end

  test "single pair win over single pair by high card" do
    assert PokerHands.run("2D 4H 7C JS JD", "2H 3C 7S JC JH") == "Black wins - single pair: four"
  end

  test "two pair tie" do
    assert PokerHands.run("2D 7H 7C JS JD", "2H 7D 7S JC JH") == "Tie"
  end

  test "two pair win over two pair" do
    assert PokerHands.run("2D KH KC JS JD", "2H 7D 7S JC JH") == "Black wins - two pair: king"
  end

  test "two pair win over two pair by high card" do
    assert PokerHands.run("2D KH KC JS JD", "3H KD KS JC JH") == "White wins - two pair: three"
  end

  test "three of a kind win over three of a kind" do
    assert PokerHands.run("2D 7H TC TS TD", "2H 7D JS JC JH") == "White wins - three of a kind: jack"
  end

  test "straight tie" do
    assert PokerHands.run("2D 3H 4C 5S 6D", "2H 3C 4S 5D 6H") == "Tie"
  end

  test "straight win over straight" do
    assert PokerHands.run("2D 3H 4C 5S 6D", "7H 3C 4S 5D 6H") == "White wins - straight: seven"
  end

  test "flush tie" do
    assert PokerHands.run("2D 3D 4D 5D 7D", "2H 3H 4H 5H 7H") == "Tie"
  end

  test "flush win over flush" do
    assert PokerHands.run("2D 3D 4D 5D 8D", "2H 3H 4H 5H 7H") == "Black wins - flush: eight"
  end

  test "full house win over full house" do
    assert PokerHands.run("2D 2H 2C 5D 5H", "3D 3H 3C 2D 2H") == "White wins - full house: three"
  end

  test "four of a kind win over four of a kind" do
    assert PokerHands.run("2D 2H 2C 2S 5H", "3D 3H 3C 3S 2H") == "White wins - four of a kind: three"
  end

  test "straight flush tie" do
    assert PokerHands.run("2D 3D 4D 5D 6D", "2H 3H 4H 5H 6H") == "Tie"
  end

  test "straight flush win over straight flush" do
    assert PokerHands.run("2D 3D 4D 5D 6D", "7H 3H 4H 5H 6H") == "White wins - straight flush: seven"
  end
end
