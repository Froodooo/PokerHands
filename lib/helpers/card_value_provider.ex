defmodule PokerHands.Helpers.CardValueProvider do
  @doc ~S"""
  Gets the numerical values of a hand of cards.

  ## Examples
      iex> PokerHands.Helpers.CardValueProvider.get_card_values([{:"2",:H},{:"3",:D},{:"5",:S},{:"9",:C},{:K,:D}])
      [2, 3, 5, 9, 13]
  """
  def get_card_values(hand) do
    Enum.map(hand, fn {x, _} -> get_card_value_order(x) end)
  end

  @doc ~S"""
  Gets the numerical values and their index in the list of a hand of cards.

  ## Examples
      iex> PokerHands.Helpers.CardValueProvider.get_card_values_indexed([{:"2",:H},{:"3",:D},{:"5",:S},{:"9",:C},{:K,:D}])
      [{2, 0},{3, 1},{5, 2},{9, 3},{13, 4}]
  """
  def get_card_values_indexed(hand) do
    get_card_values(hand) |> Enum.with_index()
  end

  @doc ~S"""
  Gets the sorted indexed numerical values from a hand with indexed numerical card values.

  ## Examples
      iex> PokerHands.Helpers.CardValueProvider.get_card_values_sorted([{2, 0},{3, 1},{5, 2},{9, 3},{13, 4}])
      [{13,4},{9,3},{5,2},{3,1},{2,0}]
  """
  def get_card_values_sorted(hand) do
    Enum.sort(hand, &(elem(&1, 0) >= elem(&2, 0)))
  end

  @doc ~S"""
  Gets the cards with highest order from a hand of indexed cards and a list of indices.

  ## Examples
      iex> PokerHands.Helpers.CardValueProvider.get_cards_with_highest_order(
      ...> [{{:"2",:H},0},{{:"3",:D},1},{{:K,:S},2},{{:"9",:C},3},{{:K,:D},4}], [2, 4])
      {true, [{:K,:S}, {:K,:D}]}
  """
  def get_cards_with_highest_order(hand_indexed, hand_highest_orders_indices) do
    hand_result =
      Enum.filter(hand_indexed, fn {_, x} -> x in hand_highest_orders_indices end)
      |> Enum.map(fn {x, _} -> x end)

    {true, hand_result}
  end

  @doc ~S"""
  Gets the cards with highest value from two hands of cards.

  ## Examples
      iex> PokerHands.Helpers.CardValueProvider.get_card_with_highest_set_value(
      ...> [K: :D],
      ...> [A: :H])
      {:white, [A: :H]}
  """
  def get_card_with_highest_set_value(black_cards_ranked, white_cards_ranked) do
    black_card_values = get_card_values_indexed(black_cards_ranked)
    white_card_values = get_card_values_indexed(white_cards_ranked)

    highest_black_card_value = Enum.at(black_card_values, 0)
    highest_white_card_value = Enum.at(white_card_values, 0)

    {card_value_black, _} = highest_black_card_value
    {card_value_white, _} = highest_white_card_value

    cond do
      card_value_black > card_value_white -> {:black, black_cards_ranked}
      card_value_white > card_value_black -> {:white, white_cards_ranked}
      true -> {:tie, nil}
    end
  end

  defp get_card_value_order(atom) do
    case atom do
      :"1" -> 1
      :"2" -> 2
      :"3" -> 3
      :"4" -> 4
      :"5" -> 5
      :"6" -> 6
      :"7" -> 7
      :"8" -> 8
      :"9" -> 9
      :T -> 10
      :J -> 11
      :Q -> 12
      :K -> 13
      :A -> 14
    end
  end
end
